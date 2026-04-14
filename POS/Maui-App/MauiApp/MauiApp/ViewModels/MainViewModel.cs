using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Input;


namespace FirstMauiMVVMApp.ViewModels;

public class MainViewModel : BindableObject
{
    private int _count;

    public int Count
    {
        get => _count;
        set
        {
            _count = value;
            OnPropertyChanged();
            OnPropertyChanged(nameof(ButtonText));
        }
    }

    public string ButtonText =>
        Count == 0 ? "Click me" : $"Clicked {Count} times";

    public ICommand ClickCommand { get; }

    public MainViewModel()
    {
        ClickCommand = new Command(OnClicked);
    }

    private void OnClicked()
    {
        Count++;
    }
}
