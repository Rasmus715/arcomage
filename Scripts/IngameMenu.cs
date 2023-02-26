using Godot;
using Arcomage.Scripts;

public class IngameMenu : Control
{
	#region Controls

	private Control _ingameSettings;

	#endregion
	
	public override void _EnterTree()
	{
		base._EnterTree();
		
		#region OnReady vars

		_ingameSettings = GetNode<Control>("settings");
		
		#endregion
	}
	
	public override void _Ready()
	{
		SetAsToplevel(true);
	}
	
	public void OnResumePressed()
	{
		Hide();
		Global.Table.GetTree().Paused = false;
	}

	public void OnSettingsPressed()
	{
		_ingameSettings.Show();
	}
	
	
	private void OnExitPressed()
	{
		GetTree().ChangeScene("res://scenes/MainMenu.tscn");
	}
}
