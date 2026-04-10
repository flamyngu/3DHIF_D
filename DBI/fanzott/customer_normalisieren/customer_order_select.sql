SELECT
    ap.auftragsnr,
    k.kunden_name,
    k.kunden_adresse,
    a.bezeichnung,
    ap.menge,
    a.preis,
    (ap.menge * a.preis) AS gesamtpreis
FROM auftragspositionen ap
JOIN kunden  k ON ap.kundennr  = k.kundennr
JOIN artikel a ON ap.artikelnr = a.artikelnr
ORDER BY ap.auftragsnr;

SELECT
    k.kunden_name,
    SUM(ap.menge * a.preis) AS gesamtumsatz
FROM auftragspositionen ap
JOIN kunden  k ON ap.kundennr  = k.kundennr
JOIN artikel a ON ap.artikelnr = a.artikelnr
GROUP BY k.kundennr, k.kunden_name
ORDER BY gesamtumsatz DESC;
