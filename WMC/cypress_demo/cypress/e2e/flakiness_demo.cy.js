const BASE_URL = "https://the-internet.herokuapp.com";

// Hardcodierte Wartezeiten (cy.wait mit fixer Millisekunden-Zahl)

describe("1. Hardcodierte Wartezeiten", () => {

  // Flaky - 500ms können manchmal zu kurz sein, manchmal zu lang -> Test schlägt manchmal fehl
  it("Flaky: Login mit cy.wait(500)", () => {
    cy.visit(`${BASE_URL}/login`);
    cy.get("#username").type("tomsmith");
    cy.get("#password").type("SuperSecretPassword!");
    cy.get('button[type="submit"]').click();

    cy.wait(500); // Vielleicht lädt die Seite in 600ms -> Test schlägt fehl

    cy.get("#flash").should("contain", "You logged into a secure area!");
  });

  // Cypress wartet automatisch bis das Element sichtbar ist
  it("Nicht flaky: Login mit automatischem Warten", () => {
    cy.visit(`${BASE_URL}/login`);
    cy.get("#username").type("tomsmith");
    cy.get("#password").type("SuperSecretPassword!");
    cy.get('button[type="submit"]').click();

    // Cypress wiederholt diese Prüfung automatisch bis zu 4 Sekunden lang
    cy.get("#flash").should("be.visible").and("contain", "You logged into a secure area!");
  });

});

// Reihenfolgeabhängige Tests (Test B hängt von Test A ab)
describe("2. Reihenfolgeabhängige Tests", () => {

  // Flaky - Wenn die Tests in anderer Reihenfolge laufen, schlägt Test 2 fehl
  context("Flaky: Zustand wird zwischen Tests geteilt", () => {
    let gespeicherterText = ""; // Globale Variable

    it("Test 1: Speichert einen Wert", () => {
      gespeicherterText = "Hello World!";
      expect(gespeicherterText).to.equal("Hello World!");
    });

    it("Test 2: Verlässt sich auf Wert aus Test 1", () => {
      // Wenn nur Test 2 einzeln ausgeführt wird -> gespeicherterText = ""
      expect(gespeicherterText).to.equal("Hello World!"); // -> fehlerhaft, weil Test 1 nicht ausgeführt wurde
    });
  });

  // Jeder Test ist vollständig unabhängig
  context("Nicht flaky: Jeder Test setzt seinen eigenen Zustand", () => {
    let gespeicherterText = "";

    beforeEach(() => {
      // beforeEach läuft vor jedem Test -> immer sauberer Ausgangszustand
      gespeicherterText = "Hello World!";
    });

    it("Test 1: Prüft den Wert", () => {
      expect(gespeicherterText).to.equal("Hello World!");
    });

    it("Test 2: Kann alleine laufen und funktioniert trotzdem", () => {
      expect(gespeicherterText).to.equal("Hello World!"); // Immer korrekt
    });
  });

});

// Dynamische/animierte Elemente
describe("3. Animierte & dynamische Elemente", () => {

  // Flaky - Element erscheint nach 2 Sekunden, aber wir klicken sofort
  it("Flaky: Klick auf Button der erst erscheint (zu früh)", () => {
    cy.visit(`${BASE_URL}/dynamic_loading/1`);
    cy.get("#start button").click();

    // Das Element #finish lädt erst nach einer Weile
    // Wenn wir sofort prüfen -> Element noch nicht da -> Test schlägt fehl
    cy.get("#finish").should("have.text", "Hello World!");
  });

  // Explizit auf Sichtbarkeit warten
  it("Nicht flaky: Warten bis Element wirklich sichtbar ist", () => {
    cy.visit(`${BASE_URL}/dynamic_loading/1`);
    cy.get("#start button").click();

    // Cypress wartet automatisch (Standard: 4 Sekunden)
    cy.get("#finish", { timeout: 10000 }) // bis zu 10 Sekunden warten
      .should("be.visible")
      .and("contain", "Hello World!");
  });

});

// Netzwerk-Abhängigkeiten (API-Calls ohne Mocking)
describe("4. Netzwerk-Abhängigkeiten", () => {

  // Flaky - Echter API-Call: Server kann langsam/offline sein
  it("Flaky: Echter API-Call ohne Kontrolle", () => {
    cy.visit(`${BASE_URL}/`);

    // Was wenn der externe Server gerade überlastet ist?
    // -> Test schlägt fehl, obwohl unser Code korrekt ist
    cy.request("https://jsonplaceholder.typicode.com/todos/1").then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.title).to.exist;
    });
  });

  // API-Antwort wird "gemockt" 
  it("Nicht flaky: API-Antwort wird simuliert (cy.intercept)", () => {
    // Wir fangen den API-Call ab und geben eine eigene Antwort zurück
    cy.intercept("GET", "https://jsonplaceholder.typicode.com/todos/1", {
      statusCode: 200,
      body: {
        id: 1,
        title: "Cypress lernen",
        completed: false,
      },
    }).as("getTodo"); // Wir benennen den Intercept "getTodo"

    cy.visit(`${BASE_URL}/`);

    // Warten bis der (simulierte) API-Call passiert ist
    // cy.wait("@getTodo");

    //  Dieser Test läuft immer gleich, egal ob Internet da ist oder nicht
    cy.log("API wurde erfolgreich gemockt! Kein echter Netzwerk-Call nötig.");
  });

});

// 
// Selektoren die sich ändern (instabile CSS-Selektoren)
// 
describe("5. Instabile Selektoren", () => {

  // Flaky - nth-child ändert sich wenn Entwickler die Reihenfolge ändert
  it("Flaky: Selektor per Position (nth-child)", () => {
    cy.visit(`${BASE_URL}/login`);

    // Was wenn der Entwickler ein neues Input-Feld hinzufügt?
    // Dann ist username plötzlich nicht mehr das 1. Input-Feld
    cy.get("form input:nth-child(1)").type("tomsmith");
    cy.get("form input:nth-child(2)").type("SuperSecretPassword!");
  });

  // Selektor per ID oder data-cy Attribut
  it(" Nicht flaky: Selektor per ID (stabil)", () => {
    cy.visit(`${BASE_URL}/login`);

    // IDs ändern sich nicht einfach -> stabiler Selektor
    cy.get("#username").type("tomsmith");
    cy.get("#password").type("SuperSecretPassword!");

    // best practice: Eigene data-cy Attribute im HTML setzen:
    // <input data-cy="username-input" />
    // cy.get('[data-cy="username-input"]').type("tomsmith");
    // -> Diese Attribute existieren nur fürs testen
  });

});
