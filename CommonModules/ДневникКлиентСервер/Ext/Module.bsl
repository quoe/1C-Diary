﻿////////////////////////////////////////////////////////////////////////////////
// ДеньгиКлиентСервер: Общий фунционал конфигурации 1С:Деньги
//	
//	* Установка отборов в списках
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ОШИБКАМИ

// Формирует текст сообщения, подставляя значения
// параметров в шаблоны сообщений.
//
// Параметры
//  ВидПоля       - Строка - может принимать значения:
//                  Поле, Колонка, Список
//  ВидСообщения  - Строка - может принимать значения:
//                  Заполнение, Корректность
//  Параметр1     - Строка - имя поля
//  Параметр2     - Строка - номер строки
//  Параметр3     - Строка - имя списка
//  Параметр4     - Строка - текст сообщения о некорректности заполнения
//
// Возвращаемое значение:
//   Строка - текст сообщения
//
Функция ПолучитьТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение",
	Параметр1 = "", Параметр2 = "",	Параметр3 = "", Параметр4 = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" не заполнено'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" заполнено некорректно.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не введено ни одной строки в список ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнен список ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметр1, Параметр2, Параметр3, Параметр4);

КонецФункции

// Функция убирает из текста сообщения служебную информацию
//
// Параметры
//  ТекстСообщения, Строка, исходный текст сообщения//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьТекстСообщения(Знач ТекстСообщения) Экспорт

	НачалоСлужебногоСообщения    = Найти(ТекстСообщения, "{");
	ОкончаниеСлужебногоСообщения = Найти(ТекстСообщения, "}:");

	Если ОкончаниеСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения < ОкончаниеСлужебногоСообщения Тогда

		ТекстСообщения = Лев(ТекстСообщения, (НачалоСлужебногоСообщения - 1)) +
		                 Сред(ТекстСообщения, (ОкончаниеСлужебногоСообщения + 2));

	КонецЕсли;

	Возврат СокрЛП(ТекстСообщения);

КонецФункции

Процедура СообщитьОбОшибке(Знач ТекстСообщения, Отказ = Ложь, Заголовок = "", Знач Статус = Неопределено, ВызыватьИсключение = Истина) Экспорт

	Если Статус = Неопределено Тогда
		Статус = СтатусСообщения.Важное;
	КонецЕсли;

	ТекстСообщения = СформироватьТекстСообщения(ТекстСообщения);
	Отказ = Истина;

	#Если ВнешнееСоединение Тогда

		Если ВызыватьИсключение Тогда
			Если ЗначениеЗаполнено(Заголовок) Тогда
				ТекстСообщения = Заголовок + Символы.ПС + ТекстСообщения;
				Заголовок = "";
			КонецЕсли;

			ВызватьИсключение (ТекстСообщения);
		КонецЕсли;

	#Иначе

		Если ЗначениеЗаполнено(Заголовок) Тогда
			Сообщить(Заголовок);
			Заголовок = "";
		КонецЕсли;

		Сообщить(ТекстСообщения, Статус);

	#КонецЕсли

КонецПроцедуры

Функция ПолучитьРеквизитФормы(ИмяРеквизита, Форма) Экспорт

	// Проверим существование добавленных реквизитов во избежание их дублирования
	МассивРеквизитов = Форма.ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из МассивРеквизитов Цикл
		Если РеквизитФормы.Имя = ИмяРеквизита Тогда
			Возврат РеквизитФормы;
		КонецЕсли; 
	КонецЦикла; 

	Возврат Неопределено;
	
КонецФункции

// Возвращает картинку, соответствующую указанному виду операции
//
//Параметры:
//	ВидОперации - Строка или ТипЗнчения - наименование или тип документа
//	
//Возвращаемое значение:
//	Картинка
Функция ПолучитьКартинкуВидаОперации(ВидОперации) Экспорт

	Если ВидОперации = "Расход" ИЛИ ВидОперации = Тип("ДокументСсылка.Расход") Тогда
		Возврат БиблиотекаКартинок.РасходИзКошелька16;
	ИначеЕсли ВидОперации = "Перемещение" ИЛИ ВидОперации = Тип("ДокументСсылка.Перемещение") Тогда
		Возврат БиблиотекаКартинок.Перемещение16;
	ИначеЕсли ВидОперации = "Доход" ИЛИ ВидОперации = Тип("ДокументСсылка.Доход") Тогда
		Возврат БиблиотекаКартинок.ДоходВКошелек16;
	ИначеЕсли ВидОперации = "ОбменВалюты" ИЛИ ВидОперации = Тип("ДокументСсылка.ОбменВалюты") Тогда
		Возврат БиблиотекаКартинок.Валюта16;
	ИначеЕсли ВидОперации = "МыДалиВДолг" ИЛИ ВидОперации = Тип("ДокументСсылка.МыДалиВДолг") Тогда
		Возврат БиблиотекаКартинок.ВыдачаЗайма16;
	ИначеЕсли ВидОперации = "НамВернулиДолг" ИЛИ ВидОперации = Тип("ДокументСсылка.НамВернулиДолг") Тогда
		Возврат БиблиотекаКартинок.ВозвратВыданногоЗайма16;
	ИначеЕсли ВидОперации = "МыВзялиВДолг" ИЛИ ВидОперации = Тип("ДокументСсылка.МыВзялиВДолг") Тогда
		Возврат БиблиотекаКартинок.МыВзялиВДолг16;
	ИначеЕсли ВидОперации = "МыВернулиДолг" ИЛИ ВидОперации = Тип("ДокументСсылка.МыВернулиДолг") Тогда
		Возврат БиблиотекаКартинок.ПогашениеПолученногоКредита16;
	ИначеЕсли ВидОперации = "ВводИзменениеОстатка" ИЛИ ВидОперации = Тип("ДокументСсылка.ВводИзменениеОстатка") Тогда
		Возврат БиблиотекаКартинок.ИзменениеОстатка16;
	ИначеЕсли ВидОперации = "УниверсальнаяОперация" ИЛИ ВидОперации = Тип("ДокументСсылка.УниверсальнаяОперация") Тогда
		Возврат БиблиотекаКартинок.УниверсальнаяОперация16;
	Иначе
		Возврат Новый Картинка;
	КонецЕсли; 
	
КонецФункции

// Возвращает результат проверки строки на ее пригодность для использования в качестве 
//	имени переменной, объекта и т.п.
//
//Параметры:
//	ИмяПеременной - Строка
//
//Возвращаемое значение
//	Булево - Истина, если строка может использоваться в качестве имени переменной, 
//			ложь, если содержит недопустимые символы или начинается с цифры
Функция ИмяПеременнойВалидно(ИмяПеременной) Экспорт

	Если ПустаяСтрока(ИмяПеременной) Тогда
		Возврат Ложь;
	КонецЕсли; 

	НачальныйСимвол = Лев(ИмяПеременной, 1);
	КодСимвола = КодСимвола(НачальныйСимвол);
	// начинаестся только с подчеркивания или буквы
	Если КодСимвола < 65
			ИЛИ (КодСимвола > 90 И КодСимвола < 95)  
			Или (КодСимвола > 95 И КодСимвола < 97) 
			Или (КодСимвола > 122 И КодСимвола < 1025) 
			Или (КодСимвола > 1025 И КодСимвола < 1040) 
			Или (КодСимвола > 1103 И КодСимвола <> 1105) Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Для СчетчикСимволов = 2 По СтрДлина(ИмяПеременной) Цикл
		КодСимвола = КодСимвола(Сред(ИмяПеременной, СчетчикСимволов, 1));
		// является буквой, цифрой или подчеркиванием
		Если КодСимвола < 48 
				ИЛИ (КодСимвола > 57 И КодСимвола < 65)  
				ИЛИ (КодСимвола > 90 И КодСимвола < 95)  
				Или (КодСимвола > 95 И КодСимвола < 97) 
				Или (КодСимвола > 122 И КодСимвола < 1025) 
				Или (КодСимвола > 1025 И КодСимвола < 1040) 
				Или (КодСимвола > 1103 И КодСимвола <> 1105) Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла; 

	Возврат Истина;
	
КонецФункции

// Устанавливает значение Отказ и выводит сообщение пользователю о невозможности открыть форму
//
//Параметры:
//	Отказ - Булево - параметр обработчика события ПриСозданииНаСервере или ПриОткрытии
//	СтандартнаяОбработка - Булево - параметр обработчика события ПриСозданииНаСервере
//	ЗаголовокФормы - Строка - заголовок формы, которую невозможно открыть
//	ПодробностиСообщения - Строка (необязательно) - информация о причинах невозможности открыть форму
//
Процедура СообщитьОНевозможностиОткрытьФорму(Отказ, СтандартнаяОбработка, ЗаголовокФормы, ПодробностиСообщения = "") Экспорт

	Отказ = Истина;
	
	ТекстСообщения = НСтр("ru = 'Форма %1 не может быть открыта.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, """" + ЗаголовокФормы + """");
	Если ЗначениеЗаполнено(ПодробностиСообщения) Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС + ПодробностиСообщения;
	КонецЕсли; 

	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

// Возвращает строку, в которой символы далее указанной длины заменены на многоточие.
//	Если указано, строка обрамляется в угловые скобки
Функция СокращенноеПредставление(СтрокаТекста, МаксимальнаяДлинаТекста = 30, ОбрамлятьСкобками = Истина) Экспорт

	ДопустимаяДлинаТекста = МаксимальнаяДлинаТекста - ?(ОбрамлятьСкобками, 2, 0);
	Результат = ?(СтрДлина(СтрокаТекста) > ДопустимаяДлинаТекста, Лев(СтрокаТекста, ДопустимаяДлинаТекста - 1) + "…", СтрокаТекста);
	Если ОбрамлятьСкобками Тогда
		Результат = "[" + Результат + "]";
	КонецЕсли;
	 
	Возврат Результат;

КонецФункции

// Удаляет указанные файлы или каталоги
//
//Параметры:
//	Файлы - Строка с именем файла/каталога или массив с именами файлов/каталогов
//
Процедура УдалитьВременныеФайлы(Файлы) Экспорт

	Если Не ЗначениеЗаполнено(Файлы) Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Файлы) = Тип("Строка") Тогда
		УдаляемыеФайлы = Новый Массив;
		УдаляемыеФайлы.Добавить(Файлы);
	Иначе
		УдаляемыеФайлы = Файлы;
	КонецЕсли;

	Для каждого УдаляемыйФайл Из УдаляемыеФайлы Цикл
		
		Если Не ПустаяСтрока(УдаляемыйФайл) Тогда
			
			Файл = Новый Файл(УдаляемыйФайл);
			Если Файл.Существует() Тогда
				УдалитьФайлы(Файл.ПолноеИмя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// * Установка отборов в списках

// Устанавливает отбор списка операций по значениям реквизитов Проведен, ПометкаУдаления
//
// Параметры:
//   НомерОтбораПоСостояниюОбъекта - Число - Может принимать значения: 1="Учтенные и черновики", 2="Только учтенные", 
//												3="Только черновики", 4="Помеченные на удаление"; (0 или 5)="Все"
//
Процедура УстановитьОтборСпискаОперацийПоСостояниюДокумента(Форма, НомерОтбораПоСостояниюОперации, ИмяСписка = "Список", ОбновлятьСтандартныеЭлементы = Истина) Экспорт
	
	ОтборДинамическогоСписка = Форма.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Форма.Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	Если ОтборДинамическогоСписка = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не найден отбор в пользовательских настройках динамического списка!'");
	КонецЕсли;
	
	ТекстЗаголовка = "";
	Если НомерОтбораПоСостояниюОперации = 1 Тогда
		
		// Проведенные и черновики: Непомеченные на удаление
		ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(ОтборДинамическогоСписка,  "Проведен", , , , Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "ПометкаУдаления", Ложь,   ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ТекстЗаголовка = НСтр("ru='учтенные и черновики'"); 
		
	ИначеЕсли НомерОтбораПоСостояниюОперации = 2 Тогда
		
		// Только проведенные
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "Проведен",      Истина,   ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "ПометкаУдаления", Ложь,   ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ТекстЗаголовка = НСтр("ru='только учтенные'"); 
		
	ИначеЕсли НомерОтбораПоСостояниюОперации = 3 Тогда
		
		// Черновики: Непроведенные и Непомеченные на удаление
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "Проведен",        Ложь,   ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "ПометкаУдаления", Ложь,   ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ТекстЗаголовка = НСтр("ru='черновики'"); 
		
	ИначеЕсли НомерОтбораПоСостояниюОперации = 4 Тогда
		
		// Помеченные на удаление
		ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(ОтборДинамическогоСписка,  "Проведен", , , , Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборДинамическогоСписка, "ПометкаУдаления", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ТекстЗаголовка = НСтр("ru='помеченные на удаление'"); 
		
	Иначе
		
		// Без отбора
		ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(ОтборДинамическогоСписка, "Проведен", , , , Ложь);
		ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(ОтборДинамическогоСписка, "ПометкаУдаления", , , , Ложь);
		
	КонецЕсли; 
	
	Если ОбновлятьСтандартныеЭлементы И Форма <> Неопределено Тогда
		
		//Форма.НастройкиПользователя.Вставить("НомерОтбораПоСостояниюОперации", НомерОтбораПоСостояниюОперации);
		ЗаголовокФормыБезОтбора = Сред(Форма.Заголовок, 1, Найти(Форма.Заголовок, " (") - 1);
		Форма.Заголовок = ЗаголовокФормыБезОтбора;
		Если ЗначениеЗаполнено(ТекстЗаголовка) Тогда
			Форма.Заголовок = Форма.Заголовок + " (" + ТекстЗаголовка + ")";
		КонецЕсли;
		
		Форма.Элементы.ОтборУчтенныеИЧерновики.Пометка    = НомерОтбораПоСостояниюОперации = 1;
		Форма.Элементы.ОтборТолькоУчтенные.Пометка        = НомерОтбораПоСостояниюОперации = 2;
		Форма.Элементы.ОтборТолькоЧерновики.Пометка       = НомерОтбораПоСостояниюОперации = 3;
		Форма.Элементы.ОтборПомеченныеНаУдаление.Пометка  = НомерОтбораПоСостояниюОперации = 4;
		Форма.Элементы.ОтборВсе.Пометка     = НомерОтбораПоСостояниюОперации = 0 ИЛИ НомерОтбораПоСостояниюОперации = 5;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// * Прочее

// Возвращает строку, разделяющую запросы в тексте. Заполненный параметр "СтрокаКомментария" 
//	будет добавлен в качестве комментария вместе с разделителем текстов.
Функция ТекстРазделителяЗапросов(СтрокаКомментария = "") Экспорт

	ТекстРазделителяЗапросов = "
	|;
	|
	|//" + ?(ЗначениеЗаполнено(СтрокаКомментария), СтрокаКомментария, "") + "//////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстРазделителяЗапросов;

КонецФункции

// Возвращает структуру описания организации для использования в регламентированном отчете 3-НДФЛ
Функция ПолучитьСтруктуруОрганизации() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ДополнительныйКодФСС", "");
	Результат.Вставить("ЕстьОбособленныеПодразделения", Ложь);
	Результат.Вставить("ИндивидуальныйПредприниматель", Истина);
	Результат.Вставить("ИНН", "");
	Результат.Вставить("КодНалоговогоОргана", "");
	Результат.Вставить("КодНалоговогоОрганаПолучателя", "");
	Результат.Вставить("ДатаРегистрации", "");
	Результат.Вставить("КодОрганаПФР", "");
	Результат.Вставить("КодОКОПФ", "");
	Результат.Вставить("ОКАТО", "");
	Результат.Вставить("ОКТМО", "");
	Результат.Вставить("НаименованиеОКОПФ", "");
	Результат.Вставить("КодОКФС", "");
	Результат.Вставить("НаименованиеОКФС", "");
	Результат.Вставить("КодОКВЭД", "");
	Результат.Вставить("ОбменКодАбонента", "");
	Результат.Вставить("НаименованиеОКВЭД", "");
	Результат.Вставить("ИностраннаяОрганизация", "");
	Результат.Вставить("НаименованиеИнострОрганизации", "");
	Результат.Вставить("СтранаРегистрации", "");
	Результат.Вставить("КодВСтранеРегистрации", "");
	Результат.Вставить("СтранаПостоянногоМестонахождения", "");
	Результат.Вставить("ОбособленноеПодразделение", Ложь);
	Результат.Вставить("ОГРН", "");
	Результат.Вставить("ВариантНаименованияДляПечатныхФорм", "");
	Результат.Вставить("РегистрационныйНомерПФР", "");
	Результат.Вставить("РегистрацияВНалоговомОргане", "");
	Результат.Вставить("СвидетельствоДатаВыдачи", '00010101');
	Результат.Вставить("СвидетельствоСерияНомер", "");
	Результат.Вставить("ТерриториальныеУсловияПФР", "");
	Результат.Вставить("УчетнаяЗаписьОбмена", "");
	Результат.Вставить("ЮридическоеФизическоеЛицо", "ФизическоеЛицо");
	
	Результат.Вставить("ИННФЛ", "");
	Результат.Вставить("КодНО", "");
	Результат.Вставить("ФИО", "");
	Результат.Вставить("ТелДом", "");
	Результат.Вставить("ДатаРожд", '00010101');
	Результат.Вставить("МестоРожд", "");
	Результат.Вставить("КодУдЛичн", "");
	Результат.Вставить("СерияУдЛичн", "");
	Результат.Вставить("НомерУдЛичн", "");
	Результат.Вставить("ОрганВыданУдЛичн", "");
	Результат.Вставить("ДатаУдЛичн", '00010101');
	Результат.Вставить("ИндексМЖ", "");
	Результат.Вставить("КодСубъектМЖ", "");
	Результат.Вставить("РайонМЖ", "");
	Результат.Вставить("ГородМЖ", "");
	Результат.Вставить("НПунктМЖ", "");
	Результат.Вставить("УлицаМЖ", "");
	Результат.Вставить("ДомМЖ", "");
	Результат.Вставить("КорпусМЖ", "");
	Результат.Вставить("КвартираМЖ", "");

	
	Возврат Результат;

КонецФункции

// Возвращает пригодную для использования в качестве ключа структуры строку, полученную из произвольной строки
Функция КлючИзСтроки(Знач ИсходнаяСтрока) Экспорт

	ИсходнаяСтрока = СокрЛП(ИсходнаяСтрока);
	
	Результат = "";
	
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	Для Счетчик = 1 По ДлинаСтроки Цикл
		
		Символ = Сред(ИсходнаяСтрока, Счетчик, 1);
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Символ)) Тогда
			Результат = Результат + "_" + Формат(Счетчик, "ЧДЦ=; ЧН=0; ЧГ=") ;
		Иначе
			Результат = Результат + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Лев(Результат, 1)) Тогда
		Результат = "_" + Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает список значений, в котором перечислены все варианты выбора варианта периода по- или от текущей даты.
//	Используется для индикаторов начальной страницы
//Отказ от иользования стандартных периодов и стандартной даты начала обусловлен:
//	1. избыточностью вариантов 
//	2. потребностью в нестандартных периодах: с начала- до конца бюджетного периода; с начала- до конца дня и т.п.
//
//Параметры:
//	Направление - число - меньше нуля - только прошлые периоды, 0-все периоды, больше нуля - только будущие периоды
//	РазрешитьПроизвольнуюДату - Булево - добавляет выбор произвольной даты
//
//Возвращаемое значение:
//	СписокЗначений
//
Функция СписокВариантовПеродаИзТекущейДаты(Направление = 0, РазрешитьПроизвольнуюДату = Истина) Экспорт

	СписокВариантов = Новый СписокЗначений;
	
	Если Направление <= 0 Тогда
		// Прошлые периоды
		
		СписокВариантов.Добавить("НачалоБюджетногоПериода", НСтр("ru='с начала бюджетного периода'")); 
		
		СписокВариантов.Добавить("НачалоДня", НСтр("ru='за день'")); 
		
		СписокВариантов.Добавить("НачалоНедели", НСтр("ru='с начала недели'")); // с 1-го дня недели
		
		СписокВариантов.Добавить("ПоследняяНеделя", НСтр("ru='за неделю'"));    // за последние 7 дней
		
		СписокВариантов.Добавить("НачалоМесяца", НСтр("ru='с начала месяца'")); // с 1-го числа
		
		СписокВариантов.Добавить("ПоследнийМесяц", НСтр("ru='за месяц'")); // за последние 30(31,...) дней
		
		СписокВариантов.Добавить("НачалоГода", НСтр("ru='с начала года'")); // с 1-го января
		
		СписокВариантов.Добавить("ПоследнийГод", НСтр("ru='за год'")); // за последние 365(366) дней
		
		Если РазрешитьПроизвольнуюДату Тогда
			Представление = НСтр("ru='с ...'"); 
			СписокВариантов.Добавить("НачалоПроизвольнойДаты", Представление); 
		КонецЕсли;
	
	КонецЕсли;
	
	Если Направление >= 0 Тогда
		// Будущие периоды
		
		Если Направление > 0 Тогда
			СписокВариантов.Добавить("НачалоДня", НСтр("ru='на сегодня'")); 
		КонецЕсли;
		
		СписокВариантов.Добавить("КонецБюджетногоПериода", НСтр("ru='до конца бюджетного периода'")); 
		
		СписокВариантов.Добавить("КонецНедели", НСтр("ru='до конца недели'")); // до 7-го дня недели
		СписокВариантов.Добавить("НеделяВперед", НСтр("ru='на неделю'"));    // на ближайшие 7 дней
		
		СписокВариантов.Добавить("КонецМесяца", НСтр("ru='до конца месяца'")); // до последнего числа месяца
		СписокВариантов.Добавить("МесяцВперед", НСтр("ru='на месяц'")); // на ближайшие 30(31,...) дней
		
		СписокВариантов.Добавить("КонецГода", НСтр("ru='с начала года'")); // с 1-го января
		СписокВариантов.Добавить("ГодВперед", НСтр("ru='на год'")); // на ближайшие 365(366) дней
		
		Если РазрешитьПроизвольнуюДату Тогда
			Представление = НСтр("ru='по ...'"); 
			СписокВариантов.Добавить("КонецПроизвольнойДаты", Представление); 
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат СписокВариантов;

КонецФункции

// Устанавливает абсолютные значения дат по указанному варианту периода.
//	В случае бюджетного периода будет использован ВариантБюджета
//
//Параметры:
//	ВидПериода> - Строка - один из вариантов функции СписокВариантовПеродаИзТекущейДаты()
//	ДатаНачала    - Дата, которую нужно изменить в соответствии с заданным видом периода
//	ДатаОкончания - Дата, которую нужно изменить в соответствии с заданным видом периода
//	ВариантБюджета - СправочникСсылка.ВариантыБюджетов - используется только для вариантов бюджетного периода
//
Процедура ОбновитьДатыПоВидуПериода(ВидПериода, ДатаНачала, ДатаОкончания, 
					ВариантБюджета = Неопределено, НачалоБюджетногоПериода = Неопределено, ОкончаниеБюджетногоПериода = Неопределено) Экспорт
	
	НачалоСегодня = НачалоДня(ТекущаяДата());
	КонецСегодня  = КонецДня(НачалоСегодня);
	СекундыДня    = 86400;
	Если (ВидПериода = "НачалоБюджетногоПериода" Или ВидПериода = "КонецБюджетногоПериода")
		И (Не ЗначениеЗаполнено(НачалоБюджетногоПериода) Или Не ЗначениеЗаполнено(ОкончаниеБюджетногоПериода)) Тогда
		ПериодБюджета = БюджетированиеВызовСервера.БюджетныйПериодПоКалендарнойДате(НачалоСегодня, ВариантБюджета);
		НачалоБюджетногоПериода    = ПериодБюджета.ДатаНачала;
		ОкончаниеБюджетногоПериода = ПериодБюджета.ДатаОкончания;
	КонецЕсли;

	
	Если ВидПериода = "НачалоБюджетногоПериода" Тогда
		
		ДатаНачала     = НачалоБюджетногоПериода;
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "КонецБюджетногоПериода" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = ОкончаниеБюджетногоПериода;
		
	ИначеЕсли ВидПериода = "НачалоДня" Или ВидПериода = "КонецДня" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "НачалоНедели" Тогда
		
		ДатаНачала     = НачалоНедели(НачалоСегодня);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "КонецНедели" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = КонецНедели(КонецСегодня);
		
	ИначеЕсли ВидПериода = "НачалоМесяца" Тогда
		
		ДатаНачала     = НачалоМесяца(НачалоСегодня);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "КонецМесяца" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = КонецМесяца(КонецСегодня);
		
	ИначеЕсли ВидПериода = "НачалоГода" Тогда 
		
		ДатаНачала     = НачалоГода(НачалоСегодня);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "КонецГода" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = КонецГода(КонецСегодня);
		
	ИначеЕсли ВидПериода = "НачалоПроизвольнойДаты" Тогда
		
		ДатаНачала     = ?(ЗначениеЗаполнено(ДатаНачала), ДатаНачала, НачалоСегодня);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "КонецПроизвольнойДаты" Тогда
		
		ДатаНачала = НачалоСегодня;
		ДатаОкончания     = ?(ЗначениеЗаполнено(ДатаОкончания), ДатаОкончания, КонецСегодня);
		
	ИначеЕсли ВидПериода = "ПоследняяНеделя" Тогда
		
		ДатаНачала     = НачалоДня(НачалоСегодня - СекундыДня * 7);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "ПоследнийМесяц" Тогда
		
		ДатаНачала     = НачалоСегодня;
		ДатаОкончания  = КонецДня(КонецСегодня + СекундыДня * 7);
		
	ИначеЕсли ВидПериода = "ПоследнийГод" Тогда
		
		ДатаНачала     = ДобавитьМесяц(НачалоСегодня, -12);
		ДатаОкончания  = КонецСегодня;
		
	ИначеЕсли ВидПериода = "НеделяВперед" Тогда
		
		ДатаНачала    = НачалоСегодня;
		ДатаОкончания = КонецДня(КонецСегодня + СекундыДня * 7);
		
	ИначеЕсли ВидПериода = "МесяцВперед" Тогда
		
		ДатаНачала    = НачалоСегодня;
		ДатаОкончания = КонецДня(ДобавитьМесяц(КонецСегодня, 1));
		
	ИначеЕсли ВидПериода = "ГодВперед" Тогда
		
		ДатаНачала    = НачалоСегодня;
		ДатаОкончания = КонецДня(ДобавитьМесяц(КонецСегодня, 12));
		
	КонецЕсли;
	
КонецПроцедуры
 

#КонецОбласти


