using Godot;

namespace Arcomage.Scripts
{
	public class Config : Node
	{
		public enum Tavern
		{
			None,
			Harmondale,
			Erathia,
			TulareanForest,
			Deyja,
			BracadaDesert,
			Celeste,
			ThePit,
			EvermornIsland,
			Nighon,
			BarrowDowns,
			Tidewater,
			Avlee,
			StoneCity
		}
		public enum AiType
		{
			Auto,
			Attack,
			Defence,
			Random
		}
		public enum Locale
		{
			en,
			ru,
			uk,
			pl,
			da
		}
		/// Default game settings
		// Window Settings
		public static bool Fullscreen { get; set; } = false;
		public static bool Borderless { get; set; } = false;
		public static int WindowWidth { get; set; } = 960;
		public static int WindowHeight { get; set; } = 540;
		public static bool Vsync { get; set; } = false;
		public static bool IntroSkip { get; set; } = false;

		// Sound Settings
		public static double MasterVolume { get; set; } = 0.5;
		public static double MusicVolume { get; set; } = 1;
		public static double SoundVolume { get; set; } = 1;
		public static bool MuteSound { get; set; } = false;

		// Starting conditions
		public static bool Singleplayer { get; set; } = true;
		public static bool SingleClick { get; set; } = true;
		public static int TowerLevels { get; set; } = 50;
		public static int WallLevels { get; set; } = 50;
		public static int QuarryLevels { get; set; } = 5;
		public static int BrickQuantity { get; set; } = 20;
		public static int MagicLevels { get; set; } = 3;
		public static int GemQuantity { get; set; } = 10;
		public static int DungeonLevels { get; set; } = 5;
		public static int RecruitQuantity { get; set; } = 20;

		// Play conditions
		public static int AutoBricks { get; set; } = 0;
		public static int AutoGems { get; set; } = 0;
		public static int AutoRecruits { get; set; } = 0;
		public static int CardsInHand { get; set; } = 6;
		public static AiType CurrentAiType { get; set; } = AiType.Auto;
	

		// Victory conditions
		public static int TowerVictory { get; set; } = 100;
		public static int ResourceVictory { get; set; } = 300;

		// Tavern presets
		public static Tavern CurrentTavern { get; set; } = Tavern.None;

		// Language settings
		public static Locale CurrentLocale { get; set; } = Locale.en;

		// Player settings
		public static string Nickname { get; set; } = "Player";
	}
}
