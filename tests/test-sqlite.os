#Использовать asserts
#Использовать sql

Перем юТест;

Процедура Инициализация()
	//ПодключитьВнешнююКомпоненту(КаталогПрограммы()+"\ext\sql\sql.dll");
КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт

	юТест = Тестирование;

	СписокТестов = Новый Массив;
	СписокТестов.Добавить("Тест_Должен_ПроверитьСоединениеОткрыто");
	СписокТестов.Добавить("Тест_Должен_ПроверитьСоединениеЗакрыто");
	СписокТестов.Добавить("Тест_Должен_ВернутьСтатусОткрыто");
	СписокТестов.Добавить("Тест_Должен_ВернутьСтатусЗакрыто");
	СписокТестов.Добавить("Тест_Должен_СоздатьБД");
	СписокТестов.Добавить("Тест_Должен_СоздатьТаблицу");
	СписокТестов.Добавить("Тест_Должен_ДобавитьСтроки");
	СписокТестов.Добавить("Тест_Должен_ВернутьИДДобавленнойтроки");
	СписокТестов.Добавить("Тест_Должен_ДолженИзменитьСтроки");
	СписокТестов.Добавить("Тест_Должен_ДолженПолучитьВыборку");

	СписокТестов.Добавить("Тест_Должен_СоздатьИнМемориБД");
	СписокТестов.Добавить("Тест_Должен_СоздатьИнМемориБДИзСоединения");

	СписокТестов.Добавить("Тест_Должен_ВернутьРезультатЗапросаПустой");
	СписокТестов.Добавить("Тест_Должен_ВернутьРезультатЗапросаНеПустой");

	Возврат СписокТестов;

КонецФункции

Процедура Тест_Должен_ПроверитьСоединениеОткрыто() Экспорт
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();
	Ожидаем.Что(Соединение.Открыто).ЭтоИстина();
	Соединение.Закрыть();
КонецПроцедуры

Процедура Тест_Должен_ПроверитьСоединениеЗакрыто() Экспорт
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();
	Соединение.Закрыть();
	Ожидаем.Что(Соединение.Открыто).ЭтоЛожь();
КонецПроцедуры

Процедура Тест_Должен_ВернутьСтатусОткрыто() Экспорт
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();
	Ожидаем.Что(Соединение.Состояние).Равно("Open");
	Соединение.Закрыть();
КонецПроцедуры

Процедура Тест_Должен_ВернутьСтатусЗакрыто() Экспорт
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();
	Соединение.Закрыть();
	Ожидаем.Что(Соединение.Состояние).Равно("Closed");
КонецПроцедуры

Процедура Тест_Должен_СоздатьБД() Экспорт
	
	ФайлБД = Новый Файл("fixtures\test.sqlite");
	ПолноеИмяБД = ФайлБД.ПолноеИмя;
	Если (ФайлБД.Существует()) Тогда
		УдалитьФайлы(ПолноеИмяБД);
	КонецЕсли;

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ПолноеИмяБД;
	Соединение.Открыть();
	Соединение.Закрыть();

	Ожидаем.Что(ФайлБД.Существует()).ЭтоИстина();

	Освободитьобъект(ФайлБД);

	УдалитьФайлы(ПолноеИмяБД);

КонецПроцедуры

Процедура Тест_Должен_СоздатьТаблицу() Экспорт
	
	ФайлБД = Новый Файл("fixtures\test-create-table.sqlite");
	ПолноеИмяБД = ФайлБД.ПолноеИмя;
	Если (ФайлБД.Существует()) Тогда
		УдалитьФайлы(ПолноеИмяБД);
	КонецЕсли;

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ПолноеИмяБД;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();
	
	Соединение.Закрыть();

КонецПроцедуры

Процедура Тест_Должен_ДобавитьСтроки() Экспорт
	
	ФайлБД = Новый Файл("fixtures\test-table-add.sqlite");
	ПолноеИмяБД = ФайлБД.ПолноеИмя;
	Если (ФайлБД.Существует()) Тогда
		УдалитьФайлы(ПолноеИмяБД);
	КонецЕсли;

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ПолноеИмяБД;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (name) values(@name)";
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	Результат = ЗапросВставка.ВыполнитьКоманду();

	Соединение.Закрыть();

	Ожидаем.Что(Результат).Равно(1);

КонецПроцедуры

Процедура Тест_Должен_ВернутьИДДобавленнойтроки() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (name) values(@name)";
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	Результат = ЗапросВставка.ВыполнитьКоманду();

	Ожидаем.Что(ЗапросВставка.ИДПоследнейДобавленнойЗаписи()).Равно(1);
	Соединение.Закрыть();


КонецПроцедуры

Процедура Тест_Должен_ДолженИзменитьСтроки() Экспорт
	
	ФайлБД = Новый Файл("fixtures\test-table-edit.sqlite");
	ПолноеИмяБД = ФайлБД.ПолноеИмя;
	Если (ФайлБД.Существует()) Тогда
		УдалитьФайлы(ПолноеИмяБД);
	КонецЕсли;

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ПолноеИмяБД;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (name) values(@name)";
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "update  users set name = @name";
	ЗапросВставка.УстановитьПараметр("name", "Сергей Александрович");
	Результат = ЗапросВставка.ВыполнитьКоманду();

	Соединение.Закрыть();

	Ожидаем.Что(Результат).Равно(1);

КонецПроцедуры


Процедура Тест_Должен_ДолженПолучитьВыборку() Экспорт

	ФайлБД = Новый Файл("fixtures\test-table-select.sqlite");
	ПолноеИмяБД = ФайлБД.ПолноеИмя;
	Если (ФайлБД.Существует()) Тогда
		УдалитьФайлы(ПолноеИмяБД);
	КонецЕсли;

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ПолноеИмяБД;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (name) values(@name)";
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "select * from users";
	ТЗ = ЗапросВставка.Выполнить().Выгрузить();

	Ожидаем.Что(ТЗ.Количество()).Равно(1);

	Соединение.Закрыть();

КонецПроцедуры

Процедура Тест_Должен_СоздатьИнМемориБД() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);
	ЗапросВставка.Текст = "Create table users (id integer, name text)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (id, name) values (@id, @name)";
	ЗапросВставка.УстановитьПараметр("id", 1);
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "select * from users";
	ТЗ = ЗапросВставка.Выполнить().Выгрузить();

	// Для каждого СтрТЗ Из ТЗ Цикл
	// 	Сообщить("id:" +СтрТЗ.id);
	// 	Сообщить("name:" + СтрТЗ.name);
	// 	// Сообщить("born:" + СтрТЗ.born);
	// КонецЦикла;

	Ожидаем.Что(ТЗ.Количество()).Равно(1);
	Ожидаем.Что(ТЗ[0][1]).Равно("Сергей");

	Соединение.Закрыть();


КонецПроцедуры

Процедура Тест_Должен_СоздатьИнМемориБДИзСоединения() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();

	Запрос = Соединение.СоздатьЗапрос();
	Запрос.Текст = "Create table users1 (id integer, name text)";
	Запрос.ВыполнитьКоманду();

	Соединение.Закрыть();

	Освободитьобъект(Соединение);

КонецПроцедуры

Процедура Тест_Должен_ВернутьРезультатЗапросаПустой() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();

	Запрос = Соединение.СоздатьЗапрос();
	Запрос.Текст = "select * from SQLITE_MASTER where type = 999";
	РезультатЗапроса = Запрос.Выполнить();

	Ожидаем.Что(РезультатЗапроса.Пустой()).ЭтоИстина();

	Соединение.Закрыть();

	Освободитьобъект(Соединение);


КонецПроцедуры

Процедура Тест_Должен_ВернутьРезультатЗапросаНеПустой() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.sqlite;
	Соединение.ИмяБазы = ":memory:";
	Соединение.Открыть();

	Запрос = Соединение.СоздатьЗапрос();
	Запрос.Текст = "select 1";
	РезультатЗапроса = Запрос.Выполнить();

	Ожидаем.Что(РезультатЗапроса.Пустой()).ЭтоЛожь();

	Соединение.Закрыть();

	Освободитьобъект(Соединение);


КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

Инициализация();
