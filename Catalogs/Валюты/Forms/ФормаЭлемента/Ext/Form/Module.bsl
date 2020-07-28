﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Параметры.Свойство("КодВалюты") Тогда
			Объект.Код = Параметры.КодВалюты;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеКраткое") Тогда
			Объект.Наименование = Параметры.НаименованиеКраткое;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеПолное") Тогда
			Объект.НаименованиеПолное = Параметры.НаименованиеПолное;
		КонецЕсли;
		
		Если Параметры.Свойство("Загружается") Тогда
			Объект.ЗагружаетсяИзИнтернета = Параметры.Загружается;
		КонецЕсли;
		
		Если Объект.ЗагружаетсяИзИнтернета Тогда
			Объект.ОсновнаяВалюта = Справочники.Валюты.ПустаяСсылка();
		КонецЕсли;
		
		Если Параметры.Свойство("ПараметрыПрописиНаРусском") Тогда
			Объект.ПараметрыПрописи = Параметры.ПараметрыПрописиНаРусском;
		КонецЕсли;
		Если Параметры.Свойство("ПараметрыПрописи") Тогда
			Объект.ПараметрыПрописи = Параметры.ПараметрыПрописи;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
		
	КонецЕсли;
	
	// ДЕНЬГИ
	// Общие настройки форм элементов справочников
	РаботаСФормамиСправочников.ФормаЭлементаПриСозданииНаСервере(ЭтаФорма);
	// Конец ДЕНЬГИ
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// ДЕНЬГИ
	Если Объект.ЗагружаетсяИзИнтернета Тогда
		Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета");
	Иначе
		Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.РучнойВвод");
	КонецЕсли;
	// Конец ДЕНЬГИ
	
	Если ЗависимыйКурсВалют Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ОсновнаяВалюта) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Необходимо указать основную валюту'"), ,
				"Объект.ОсновнаяВалюта", ,
				Отказ);
		КонецЕсли;
	Иначе
		Объект.ОсновнаяВалюта = Неопределено;
		Объект.Наценка = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПараметрыПрописи = ПараметрыПрописиНаРусском(ЭтотОбъект);
	
КонецПроцедуры

// ДЕНЬГИ
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьТекущийКурсВалюты(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КурсыВалют" Тогда
		ОбновитьТекущийКурсВалютыСервер();
	КонецЕсли;
	
КонецПроцедуры

// Конец ДЕНЬГИ

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница "Основные сведения"

&НаКлиенте
Процедура ЗагружаетсяИзИнтернетаПриИзменении(Элемент)
	
	Если Объект.ЗагружаетсяИзИнтернета Тогда
		ЗависимыйКурсВалют = Ложь;
		Объект.ОсновнаяВалюта = Неопределено;
		Объект.Наценка = 0;
	КонецЕсли;
	
	УстановитьСвойстваЭлементовГруппыЗависимойВалюты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗависимыйКурсВалютПриИзменении(Элемент)
	
	УстановитьСвойстваЭлементовГруппыЗависимойВалюты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяВалютаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница "Параметры прописи валюты"

&НаКлиенте
Процедура СуммаЧислоПриИзменении(Элемент)
	
	УстановитьСуммуПрописью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомПриИзменении(Элемент)
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомПриИзменении(Элемент)
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи1наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи2наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи3наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи5наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи6наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи7наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	ЗависимыйКурсВалют = ЗначениеЗаполнено(Объект.ОсновнаяВалюта);
	
	ПрочитатьПараметрыПрописи();
	
	УстановитьСвойстваЭлементовГруппыЗависимойВалюты(ЭтотОбъект);
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
	
	// ДЕНЬГИ
	// 
	Если Не ЗначениеЗаполнено(ВалютаУчета) Тогда
		ВалютаУчета        = Константы.ВалютаУчета.Получить();
	КонецЕсли;
	ОбновитьТекущийКурсВалюты(ЭтотОбъект);
	// Конец ДЕНЬГИ

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПрописиНаРусском(Форма)
	
	Возврат Форма.ПолеПрописи1наРусском + ", "
			+ Форма.ПолеПрописи2наРусском + ", "
			+ Форма.ПолеПрописи3наРусском + ", "
			+ НРег(Лев(Форма.ПолеПрописи4наРусском, 1)) + ", "
			+ Форма.ПолеПрописи5наРусском + ", "
			+ Форма.ПолеПрописи6наРусском + ", "
			+ Форма.ПолеПрописи7наРусском + ", "
			+ НРег(Лев(Форма.ПолеПрописи8наРусском, 1)) + ", "
			+ Форма.ДлинаДробнойЧасти;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСуммуПрописью(Форма)
	
	Форма.СуммаПрописью = ЧислоПрописью(Форма.СуммаЧисло, , ПараметрыПрописиНаРусском(Форма));
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПараметрыПрописи()
	
	// Считывает параметры прописи и заполняет соответствующие поля диалога.
	
	СтрокаПараметров = СтрЗаменить(Объект.ПараметрыПрописи, ",", Символы.ПС);
	
	ПолеПрописи1наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 1));
	ПолеПрописи2наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 2));
	ПолеПрописи3наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 3));
	
	Род = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 4));
	
	Если	  НРег(Род) = "м" Тогда
		ПолеПрописи4наРусском = "Мужской";
	ИначеЕсли НРег(Род) = "ж" Тогда
		ПолеПрописи4наРусском = "Женский";
	ИначеЕсли НРег(Род) = "с" Тогда
		ПолеПрописи4наРусском = "Средний";
	КонецЕсли;
	
	ПолеПрописи5наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 5));
	ПолеПрописи6наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 6));
	ПолеПрописи7наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 7));
	
	Род = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 8));
	
	Если	  НРег(Род = "м") Тогда
		ПолеПрописи8наРусском = "Мужской";
	ИначеЕсли НРег(Род = "ж") Тогда
		ПолеПрописи8наРусском = "Женский";
	ИначеЕсли НРег(Род = "с") Тогда
		ПолеПрописи8наРусском = "Средний";
	КонецЕсли;
	
	ДлинаДробнойЧасти     = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 9));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовГруппыЗависимойВалюты(Форма)
	
	// ДЕНЬГИ
	// Не используются зависимые валюты
	Возврат;
	// Конец ДЕНЬГИ

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.ЗагружаетсяИзИнтернета Тогда
		Элементы.ГруппаЗависимыйКурсВалют.Доступность = Ложь;
		ФлагПараметровЗависимогоКурса = Ложь;
	Иначе
		Элементы.ГруппаЗависимыйКурсВалют.Доступность = Истина;
		ФлагПараметровЗависимогоКурса = Форма.ЗависимыйКурсВалют;
	КонецЕсли;
	
	Элементы.ОсновнаяВалюта.АвтоОтметкаНезаполненного = ФлагПараметровЗависимогоКурса;
	Элементы.Наценка.АвтоОтметкаНезаполненного = ФлагПараметровЗависимогоКурса;
	Элементы.ОсновнаяВалюта.Доступность = ФлагПараметровЗависимогоКурса;
	Элементы.Наценка.Доступность = ФлагПараметровЗависимогоКурса;
	Если НЕ ФлагПараметровЗависимогоКурса Тогда
		Элементы.ОсновнаяВалюта.ОтметкаНезаполненного = ФлагПараметровЗависимогоКурса;
		Элементы.Наценка.ОтметкаНезаполненного = ФлагПараметровЗависимогоКурса;
	КонецЕсли
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСклоненияПараметровПрописи(Форма)
	
	// Склонение заголовков параметров прописи
	
	Элементы = Форма.Элементы;
	
	Если Форма.ПолеПрописи4наРусском = "Женский" Тогда
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Одна'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Две'");
	ИначеЕсли Форма.ПолеПрописи4наРусском = "Мужской" Тогда
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Один'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Два'");
	Иначе
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Одно'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Два'");
	КонецЕсли;
	
	Если Форма.ПолеПрописи8наРусском = "Женский" Тогда
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Одна'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Две'");
	ИначеЕсли Форма.ПолеПрописи8наРусском = "Мужской" Тогда
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Один'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Два'");
	Иначе
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Одно'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Два'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Ссылка)
	
	// Подготавливает список выбора для подчиненной валюты таким образом,
	// что бы в список не попала сама подчиненная валюта
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ Ссылка, НаименованиеПолное
	               |ИЗ
	               |	Справочник.Валюты
	               |ГДЕ
	               |	Ссылка <> &Ссылка
	               |И
	               |	ОсновнаяВалюта  = Значение(Справочник.Валюты.ПустаяСсылка)
	               |УПОРЯДОЧИТЬ ПО НаименованиеПолное";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.НаименованиеПолное);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка)
	
	// Вспомогательная функция управлением вводом
	
	Для Каждого ЭлементВыбора Из Элемент.СписокВыбора Цикл
		Если ВРег(Текст) = ВРег(Лев(ЭлементВыбора.Представление, СтрДлина(Текст))) Тогда
			Результат = Новый СписокЗначений;
			Результат.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
			СтандартнаяОбработка = Ложь;
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка)
	
	// Вспомогательная функция управлением вводом
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого ЭлементВыбора Из Элемент.СписокВыбора Цикл
		Если ВРег(Текст) = ВРег(ЭлементВыбора.Представление) Тогда
			СтандартнаяОбработка = Истина;
		ИначеЕсли ВРег(Текст) = ВРег(Лев(ЭлементВыбора.Представление, СтрДлина(Текст))) Тогда
			СтандартнаяОбработка = Ложь;
			Результат = Новый СписокЗначений;
			Результат.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции


// ДЕНЬГИ

&НаСервереБезКонтекста 
Процедура ОбновитьТекущийКурсВалюты(Форма)

	Форма.ПредставлениеТекущегоКурса     = "";
	Форма.ПредставлениеДатыТекущегоКурса = "";
	Форма.ДатаКурса = Неопределено;
	
	СтруктураКурса = ?(Форма.Объект.Ссылка.Пустая(), Неопределено,  РаботаСКурсамиВалют.ПолучитьКурсВалюты(Форма.Объект.Ссылка, КонецГода(ТекущаяДатаСеанса())));
	
	Если СтруктураКурса = Неопределено Или Не ЗначениеЗаполнено(СтруктураКурса.Курс) Тогда
		
		Форма.ПредставлениеТекущегоКурса = НСтр("ru='Курс не задан'");
		Если Форма.Элементы.ГруппаТекущийКурс.Доступность Тогда
			Форма.Элементы.ГруппаТекущийКурс.Доступность = Ложь;
		КонецЕсли;
		
	Иначе
		
		Форма.ПредставлениеТекущегоКурса = НСтр("ru='%1 %2 за %3 %4'");
		Форма.ПредставлениеТекущегоКурса = СтрШаблон(Форма.ПредставлениеТекущегоКурса, 
				Формат(СтруктураКурса.Курс, "ЧДЦ=4; ЧГ="), Форма.ВалютаУчета,
				Формат(СтруктураКурса.Кратность, "ЧДЦ=0; ЧГ="), Форма.Объект.Наименование
				);
		
		Форма.ПредставлениеДатыТекущегоКурса = НСтр("ru='установлен на %1'");
		Форма.ДатаКурса = СтруктураКурса.Период;
		Если ЗначениеЗаполнено(Форма.ДатаКурса) Тогда
			Форма.ПредставлениеДатыТекущегоКурса = СтрШаблон(Форма.ПредставлениеДатыТекущегоКурса, Формат(Форма.ДатаКурса, "ДФ=дд.ММ.гггг"));
		КонецЕсли;
		
		Если Не Форма.Элементы.ГруппаТекущийКурс.Доступность Тогда
			Форма.Элементы.ГруппаТекущийКурс.Доступность = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере 
Процедура ОбновитьТекущийКурсВалютыСервер()
	ОбновитьТекущийКурсВалюты(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКурс(Команда)
	
	ТекущаяДата = НачалоДня(ТекущаяДата());
	ЗначенияЗаполнения = Новый Структура("Период,Валюта,БазоваяВалюта", ТекущаяДата, Объект.Ссылка, ВалютаУчета);
	Если ДатаКурса < ТекущаяДата  Тогда
		ОткрытьФорму("РегистрСведений.КурсыВалют.ФормаЗаписи", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтотОбъект, Объект.Ссылка);
	Иначе
		ПараметрыКлюча = Новый Массив;
		ПараметрыКлюча.Добавить(ЗначенияЗаполнения);
		Ключ = Новый(Тип("РегистрСведенийКлючЗаписи.КурсыВалют"), ПараметрыКлюча);
		ОткрытьФорму("РегистрСведений.КурсыВалют.ФормаЗаписи", Новый Структура("Ключ, ЗначенияЗаполнения", Ключ, ЗначенияЗаполнения), ЭтотОбъект, Объект.Ссылка);
	КонецЕсли; 
	
КонецПроцедуры

// Конец ДЕНЬГИ

#КонецОбласти
