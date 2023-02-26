using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Godot;
using Godot.Collections;
using Microsoft.AspNetCore.SignalR.Client;

namespace Arcomage.Scripts
{
	public class HubScreen : Control
	{
		private HubConnection _connection;
		
		private Label _connectionState;
		private ItemList _gamesList;
		
		public override void _EnterTree()
		{
			base._EnterTree();
			_connectionState = GetNode<Label>("ConnectionState");
			_gamesList = GetNode<ItemList>("AvailableGames");
		}
		
		//TODO: I need a fucking transition
		public override async void _Ready()
		{
			try
			{
				await OnEstablishConnectionPressed();
			}
			catch(Exception ex)
			{
				_connectionState.Text = "Unable to connect to web server";
				GD.Print(ex.Message);
			}
			
		}

		private void OnUpdateArcomageHub(List<ArcomageHub> arcomageHubs)
		{
			_gamesList.Clear();
			arcomageHubs.ForEach(hub =>
			{
				_gamesList.AddItem(hub.Name);
			});
		}

		private void OnCancelPressed()
		{
			Hide();
		}
		
			
		private void OnTerminateConnectionPressed()
		{
			_gamesList.Clear();
			_connection.StopAsync();
			_connectionState.Text = "Connection terminated by force";
		}
	
		private async Task OnEstablishConnectionPressed()
		{
			var connectionString = "http://localhost:5000/game";
			_connection = new HubConnectionBuilder().WithUrl(connectionString).Build();
			_connection.On<List<ArcomageHub>>("AvailableGameHubs", OnUpdateArcomageHub);
			await _connection.StartAsync();
			_connectionState.Text = $"Connection to {connectionString} established successfully";
		}

	}

	public class ArcomageHub
	{
		public Guid Id { get; set; }
		public string Name { get; set; }
		public string CreatedAt { get; set; }
		public bool IsPasswordProtected { get; set; }
		public string Password { get; set; }

	}
	
}
