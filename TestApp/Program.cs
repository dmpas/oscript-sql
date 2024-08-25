/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using OneScript.StandardLibrary;
using ScriptEngine.HostedScript;
using ScriptEngine.HostedScript.Library;
using ScriptEngine.Hosting;

namespace TestApp
{
	class MainClass : IHostApplication
	{

		static readonly string SCRIPT = @"// Отладочный скрипт в котором уже подключена наша компонента
		Соединение = Новый Соединение();
		Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
		Соединение.ИмяБазы = "":memory:"";
		Соединение.Открыть();

		Запрос = Новый Запрос();
		Запрос.УстановитьСоединение(Соединение);
		Запрос.Текст = ""Create table users (id integer, name text)"";
		Запрос.ВыполнитьКоманду();

		Запрос.Текст = ""insert into users (id, name) values(1, @name)"";
		Запрос.УстановитьПараметр(""name"", ""Сергей"");
		Запрос.ВыполнитьКоманду();

		Запрос.Текст = ""insert into users (id, name) values(@id, @name)"";
		Запрос.УстановитьПараметр(""id"", ""2"");
		Запрос.УстановитьПараметр(""name"", ""Оксана"");
		Запрос.ВыполнитьКоманду();

		Запрос2 = Новый Запрос();
		Запрос2.УстановитьСоединение(Соединение);
		Запрос2.Текст = ""select * from users where id = @id"";
		    
		Для Инд = 1 По 2 Цикл
			Запрос2.УстановитьПараметр(""id"", Инд);
			ТЗ = Запрос2.Выполнить().Выгрузить();

			Для каждого Стр Из ТЗ Цикл
				Сообщить(""Имя: "" + Стр.Name + "" ("" + Стр.id + "")"")
			КонецЦикла;

		КонецЦикла;
		
		Соединение.Закрыть();"
			;

		public static HostedScriptEngine StartEngine()
		{
			var mainEngine = DefaultEngineBuilder.Create()
				.SetDefaultOptions()
				.SetupEnvironment(envSetup =>
				{
					envSetup.AddAssembly(typeof(OScriptSql.DBConnector).Assembly);
				})
				.Build();
			var engine = new HostedScriptEngine(mainEngine);
			engine.Initialize();

			return engine;
		}

		public static void Main(string[] args)
		{
			var engine = StartEngine();
			var script = engine.Loader.FromString(SCRIPT);
			var process = engine.CreateProcess(new MainClass(args), script);

			var result = process.Start();

			Console.WriteLine("Result = {0}", result);
		}

		private string[] args;

		public MainClass(string[] args)
		{
			this.args = args;
		}

		public void Echo(string str, MessageStatusEnum status = MessageStatusEnum.Ordinary)
		{
			Console.WriteLine(str);
		}

		public void ShowExceptionInfo(Exception exc)
		{
			Console.WriteLine(exc.ToString());
		}

		public bool InputString(out string result, string prompt, int maxLen, bool multiline)
		{
			throw new NotImplementedException();
		}

		public bool InputString(out string result, int maxLen)
		{
			throw new NotSupportedException();
		}

		public string[] GetCommandLineArguments()
		{
			return args;
		}
	}
}
