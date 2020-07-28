﻿////////////////////////////////////////////////////////////////////////////////
//Обработка.НачальнаяСтраница.Форма.НастройкаИндикатораСобытий
//  используется для добавления и изменения индикатора событий
//  
//Параметры формы:
//  все свойства индикатора событий. Подробней см.  Обработка.НачальнаяСтраница.Форма.Обзор.НоваяНастройкаИндикатораДинамики()
//  
////////////////////////////////////////////////////////////////////////////////


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ИменаСвойствИндикатора());
	ЗаголовокИндикатора = Параметры.Заголовок;
	
	// Обновим значение вида периода
	Период = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Параметры.Период);
	Если ТипЗнч(Период) = Тип("Структура") Тогда
		ВидПериода    = Период.ВидПериода;
		ДатаНачала    = Период.ДатаНачала;
		ДатаОкончания = Период.ДатаОкончания;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбораПериодов();
	ОбновитьСписокВалют();
	ОбновитьСписокЦелей();
	
	// Проверяем основные свойства
	Если Не ЗначениеЗаполнено(ТипИндикатора) Тогда
		ТипИндикатора    = "Структура";
		ВидОбъектовУчета = "Расходы";
		ДополнительныеПараметрыИндикатора = Обработки.НачальнаяСтраница.ДополнительныеПараметрыПоТипуИндикатора(ТипИндикатора);
	Иначе
		ДополнительныеПараметрыИндикатора = Параметры.ДополнительныеПараметрыИндикатора;
	КонецЕсли;
	
	Если ТипЗнч(ДополнительныеПараметрыИндикатора) = Тип("Структура") Тогда
		ЗаполнитьФормуИзДополнительныхПараметров(ДополнительныеПараметрыИндикатора);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидОбъектовУчета) Тогда
		ВидОбъектовУчета = "Расходы";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидДенег) Тогда
		ВидДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги;
	КонецЕсли;
	
	МинимальнаяВысотаДиаграммы = Макс(МинимальнаяВысотаДиаграммы, 6);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПериодаДинамикаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидПериода) Тогда
		ВидПериода = Элементы.ВидПериодаДинамика.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаСтруктураПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидПериода) Тогда
		ВидПериода = Элементы.ВидПериодаСтруктура.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаПланыПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидПериода) Тогда
		ВидПериода = Элементы.ВидПериодаПланы.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипИндикатораПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ТипИндикатора) Тогда
		ТипИндикатора    = "Структура";
		ВидОбъектовУчета = "Расходы";
		ВидДенег         = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.СвободныеДеньги");
	КонецЕсли;
	
	ТипИндикатораПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектовУчетаСтруктураПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидОбъектовУчета) Тогда
		ВидОбъектовУчета = Элементы.ВидОбъектовУчетаСтруктура.СписокВыбора[0].Значение;
	КонецЕсли;
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	ОбновитьСписокОтмеченныхВидовДвиженийДенег();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектовУчетаДинамикаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидОбъектовУчета) Тогда
		ВидОбъектовУчета = Элементы.ВидОбъектовУчетаДинамика.СписокВыбора[0].Значение;
	КонецЕсли;
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДенегПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидДенег) Тогда
		ВидДенег = Элемент.СписокВыбора[0].Значение;
	КонецЕсли;
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	ОбновитьСписокОтмеченныхВидовДвиженийДенег();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСрочностиЦелиПриИзменении(Элемент)
	
	Если ВидСрочностиЦели = 0 Тогда
		СрочностьЦели = "";
		СписокЦелей.Очистить();
	ИначеЕсли ВидСрочностиЦели = 1 Тогда
		СрочностьЦели = Истина;
		СписокЦелей.Очистить();
	ИначеЕсли ВидСрочностиЦели = 2 Тогда
		СрочностьЦели = Ложь;
		СписокЦелей.Очистить();
	Иначе
		СрочностьЦели = "";
		
	КонецЕсли;
	 
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипРазделаБюджетаПриИзменении(Элемент)
	
	Если ТипРазделаБюджета = 2 Тогда
		РазделБюджета = "";
	Иначе
		Если РазделБюджета = 0 Тогда
			ФинансоваяЦельБюджета = ПредопределенноеЗначение("Справочник.ФинансовыеЦели.ПустаяСсылка");
		КонецЕсли;
		РазделБюджета = ФинансоваяЦельБюджета;
	КонецЕсли;
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФинансоваяЦельБюджетаПриИзменении(Элемент)
	РазделБюджета = ФинансоваяЦельБюджета;
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВыделенныеВалютыПриИзменении(Элемент)
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОтмеченныеВидыДвиженийДенегПриИзменении(Элемент)
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура МинимальнаяВысотаДиаграммыПриИзменении(Элемент)
	МинимальнаяВысотаДиаграммы = Макс(МинимальнаяВысотаДиаграммы, 6);
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	СовершитьВыбор();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуИзДополнительныхПараметров(СтруктураПараметров)

	Для каждого КлючИЗначение Из СтруктураПараметров Цикл
		
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда
			ЭтотОбъект[КлючИЗначение.Ключ] = ОбщегоНазначенияКлиентСервер.СкопироватьСписокЗначений(КлючИЗначение.Значение);
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Массив") Тогда
			ЭтотОбъект[КлючИЗначение.Ключ].ЗагрузитьЗначения(КлючИЗначение.Значение);
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("ТаблицаЗначений") Тогда
			ЭтотОбъект[КлючИЗначение.Ключ].Загрузить(КлючИЗначение.Значение);
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Структура") Тогда
			ЭтотОбъект[КлючИЗначение.Ключ] = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(КлючИЗначение.Значение);
		Иначе
			ЭтотОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	// Отметки в списках
	ОбновитьОтметкиВСпискеВалют();
	ОбновитьОтметкиВСпискеЦелей();
	ОбновитьСписокОтмеченныхВидовДвиженийДенег();
	
	Если СрочностьЦели = "" Тогда
		ВидСрочностиЦели = ?(СписокЦелей.Количество() = 0, 0, 3);
	ИначеЕсли ТипЗнч(СрочностьЦели) = Тип("Булево") Тогда
		ВидСрочностиЦели = ?(СрочностьЦели, 1, 2);
	КонецЕсли;
	
	Если ТипЗнч(РазделБюджета) = Тип("Строка") Тогда
		
		ТипРазделаБюджета = 2;
		
	ИначеЕсли ТипЗнч(РазделБюджета) = Тип("СправочникСсылка.ФинансовыеЦели") Тогда
		
		ТипРазделаБюджета = ?(РазделБюджета = Справочники.ФинансовыеЦели.ПустаяСсылка(), 0, 1);
		
	КонецЕсли;
	ФинансоваяЦельБюджета = РазделБюджета;
	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИменаСвойствИндикатора()

	Возврат "Ключ,ТипИндикатора,ВидОбъектовУчета";

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	
	Элементы.ГруппаСтраницНастроек.ТекущаяСтраница = Элементы["Страница" + Форма.ТипИндикатора];
	Элементы.ГруппаОтмеченныеЦели.Доступность = Форма.ВидСрочностиЦели = 3;
	Элементы.ФинансоваяЦельБюджета.Доступность = Форма.ТипРазделаБюджета = 1;

КонецПроцедуры

&НаСервере
Процедура ТипИндикатораПриИзмененииСервер()

	ДополнительныеПараметрыИндикатора = Обработки.НачальнаяСтраница.ДополнительныеПараметрыПоТипуИндикатора(ТипИндикатора);
	ЗаполнитьФормуИзДополнительныхПараметров(ДополнительныеПараметрыИндикатора);
	ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПериодов()

	СкопироватьСписокНаФорму(Элементы.ВидПериодаПланы.СписокВыбора, ДеньгиКлиентСервер.СписокВариантовПеродаИзТекущейДаты(1, Ложь));
	СкопироватьСписокНаФорму(Элементы.ВидПериодаСтруктура.СписокВыбора, ДеньгиКлиентСервер.СписокВариантовПеродаИзТекущейДаты(-1, Ложь));
	СкопироватьСписокНаФорму(Элементы.ВидПериодаДинамика.СписокВыбора, ДеньгиКлиентСервер.СписокВариантовПеродаИзТекущейДаты(-1, Ложь));

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВалют()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВалютаУчета", ПараметрыСеанса.ВалютаУчета);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Активность
	|	И Валюты.Ссылка <> &ВалютаУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.Наименование";
	
	ОтмеченныеВалюты.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЦелей()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФинансовыеЦели.Ссылка
	|ИЗ
	|	Справочник.ФинансовыеЦели КАК ФинансовыеЦели
	|ГДЕ
	|	ФинансовыеЦели.Активность И НЕ ФинансовыеЦели.Предопределенный
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФинансовыеЦели.Наименование";
	
	ОтмеченныеЦели.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

КонецПроцедуры

&НаСервере
Процедура ОбновитьОтметкиВСпискеВалют()

	Для каждого ЭлементСписка Из ОтмеченныеВалюты Цикл
		ЭлементСписка.Пометка = СписокВалют.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьОтметкиВСпискеЦелей()

	Для каждого ЭлементСписка Из ОтмеченныеЦели Цикл
		ЭлементСписка.Пометка = СписокЦелей.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокОтмеченныхВидовДвиженийДенег()

	ОтмеченныеВидыДвиженийДенег.Очистить();
	ОтмеченоВсе         = СписокВидовДвиженияДенег.Количество() = 0;
	ВключатьПеремещения = ОтмеченоВсе;
	
	Если ВидОбъектовУчета = "Доходы" Тогда
		
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ДоходыПоСтатьям);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПродажаИмущества);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВозвратВыданныхДолгов);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВзятиеДенегВДолг);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВзаимныеРасчеты);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПереводИзДругихКошельков);
		Если ВидДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги Тогда
			ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПереводИзНакоплений);
		ИначеЕсли ВидДенег = ПланыСчетов.РазделыУчета.Накопления Тогда
			ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПереводВНакопления);
		КонецЕсли;
		
	ИначеЕсли ВидОбъектовУчета = "Расходы" Тогда
		
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.РасходыПоСтатьям);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ПокупкаИмущества);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ВыдачаВДолг);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ВозвратВзятыхДолгов);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ВзаимныеРасчеты);
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ПереводВДругиеКошельки);
		Если ВидДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги Тогда
			ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ПереводВНакопления);
		ИначеЕсли ВидДенег = ПланыСчетов.РазделыУчета.Накопления Тогда
			ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыРасходов.ПереводИзНакоплений);
		КонецЕсли;
		 
	ИначеЕсли ВидОбъектовУчета = "ДоходыИРасходы" Тогда
		
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ДоходыПоСтатьям, НСтр("ru='Доходы/расходы по статьям'"));
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПродажаИмущества, НСтр("ru='Покупка/продажа имущества'"));
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВозвратВыданныхДолгов, НСтр("ru='Расчеты по выданным долгам'"));
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВзятиеДенегВДолг, НСтр("ru='Расчеты по взятым долгам'"));
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ВзаимныеРасчеты, НСтр("ru='Взаимные расчеты'"));
		ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПереводИзДругихКошельков, НСтр("ru='Переводы по кошелькам'"));
		Если ВидДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги Или ВидДенег = ПланыСчетов.РазделыУчета.Накопления Тогда
			ДобавитьВидДвиженияВСписок(СписокВидовДвиженияДенег, ОтмеченоВсе, ОтмеченныеВидыДвиженийДенег, 
						Перечисления.ВидыДоходов.ПереводИзНакоплений, НСтр("ru='Переводы в/из накоплений'"));
		КонецЕсли;
		 
	КонецЕсли;

	Если НЕ ОтмеченоВсе Тогда
		
		Для каждого ЭлементСписка Из СписокВидовДвиженияДенег Цикл
			
			Если ЭлементСписка.Значение = Перечисления.ВидыДоходов.ПереводИзДругихКошельков Или ЭлементСписка.Значение = Перечисления.ВидыРасходов.ПереводВДругиеКошельки Тогда
				ВключатьПеремещения = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьВидДвиженияВСписок(СписокИзНастроек, ОтмеченоВсе, Список, ВидДвижения, Представление = "")

	Список.Добавить(ВидДвижения, Представление, 
				ОтмеченоВсе Или СписокИзНастроек.НайтиПоЗначению(ВидДвижения) <> Неопределено);

КонецПроцедуры
 

&НаСервере
Процедура СкопироватьСписокНаФорму(СписокФормы, ОригинальныйСписок)

	СписокФормы.Очистить();
	Для каждого ЭлементСписка Из ОригинальныйСписок Цикл
		
		СписокФормы.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
		
	КонецЦикла;
	 

КонецПроцедуры

&НаКлиенте
Процедура СовершитьВыбор()

	Выбор = ПолучитьСтруктуруВыбора();
	Закрыть(Выбор);

КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруВыбора()

	Если Не ЗначениеЗаполнено(ЗаголовокИндикатора) Тогда
		ЗаголовокИндикатора = ПредставлениеИндикатораДинамики(ЭтотОбъект);
	КонецЕсли;
	
	Результат = Новый Структура("Заголовок," + ИменаСвойствИндикатора());
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	Результат.Вставить("Заголовок", ЗаголовокИндикатора);
	Результат.Вставить("Период", Новый Структура("ВидПериода,ДатаНачала,ДатаОкончания", ВидПериода, ДатаНачала, ДатаОкончания));
	
	СписокВалют.Очистить();
	Для каждого ЭлементСписка Из ОтмеченныеВалюты Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокВалют.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
		
		Если СписокВалют.Количество() = 5 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	СписокЦелей.Очистить();
	Если ВидСрочностиЦели = 3 Тогда
		Для каждого ЭлементСписка Из ОтмеченныеЦели Цикл
			Если ЭлементСписка.Пометка Тогда
				СписокЦелей.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ВключатьПеремещения = Ложь;
	СписокВидовДвиженияДенег.Очистить();
	Счетчик = 0;
	Для каждого ЭлементСписка Из ОтмеченныеВидыДвиженийДенег Цикл
		
		Если ЭлементСписка.Пометка Тогда
			
			Счетчик = Счетчик + 1;
			СписокВидовДвиженияДенег.Добавить(ЭлементСписка.Значение);
			Если ВидОбъектовУчета = "ДоходыИРасходы" Тогда
				СписокВидовДвиженияДенег.Добавить(ЗеркальноеЗначениеВидаДвиженияДенег(ЭлементСписка.Значение));
			КонецЕсли;
			Если ЭлементСписка.Значение = Перечисления.ВидыДоходов.ПереводИзДругихКошельков Или ЭлементСписка.Значение = Перечисления.ВидыРасходов.ПереводВДругиеКошельки Тогда
				ВключатьПеремещения = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	Если Счетчик = ОтмеченныеВидыДвиженийДенег.Количество() Тогда
		СписокВидовДвиженияДенег.Очистить();
		ВключатьПеремещения = Истина;
	КонецЕсли;
	
	ДопПараметры = Обработки.НачальнаяСтраница.ДополнительныеПараметрыПоТипуИндикатора(Результат.ТипИндикатора);
	Для каждого КлючИЗначение Из ДопПараметры Цикл
		
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда
			ДопПараметры[КлючИЗначение.Ключ] = ОбщегоНазначенияКлиентСервер.СкопироватьСписокЗначений(ЭтотОбъект[КлючИЗначение.Ключ]);
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("ТаблицаЗначений") Тогда
			ДопПараметры[КлючИЗначение.Ключ].Загрузить(ЭтотОбъект[КлючИЗначение.Ключ]);
		ИначеЕсли ТипЗнч(КлючИЗначение.Значение) = Тип("Структура") Тогда
			ДопПараметры[КлючИЗначение.Ключ] = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ЭтотОбъект[КлючИЗначение.Ключ]);
		Иначе
			ДопПараметры[КлючИЗначение.Ключ] = ЭтотОбъект[КлючИЗначение.Ключ];
		КонецЕсли;
		
	КонецЦикла;
	
	Результат.Вставить("ДополнительныеПараметры", ДопПараметры);

	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗеркальноеЗначениеВидаДвиженияДенег(ВидДвижения)

	Если ВидДвижения = Перечисления.ВидыДоходов.ВзаимныеРасчеты Тогда
		Возврат Перечисления.ВидыРасходов.ВзаимныеРасчеты;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ВзятиеДенегВДолг Тогда
		Возврат Перечисления.ВидыРасходов.ВозвратВзятыхДолгов;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ВозвратВыданныхДолгов Тогда
		Возврат Перечисления.ВидыРасходов.ВыдачаВДолг;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ДоходыПоСтатьям Тогда
		Возврат Перечисления.ВидыРасходов.РасходыПоСтатьям;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ОбменВалюты Тогда
		Возврат Перечисления.ВидыРасходов.ОбменВалюты;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ПереводВНакопления Тогда
		Возврат Перечисления.ВидыРасходов.ПереводИзНакоплений;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ПереводИзНакоплений Тогда
		Возврат Перечисления.ВидыРасходов.ПереводВНакопления;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ПереводИзДругихКошельков Тогда
		Возврат Перечисления.ВидыРасходов.ПереводВДругиеКошельки;
	ИначеЕсли ВидДвижения = Перечисления.ВидыДоходов.ПродажаИмущества Тогда
		Возврат Перечисления.ВидыРасходов.ПокупкаИмущества;
	КонецЕсли;
	
	Возврат Перечисления.ВидыРасходов.ПустаяСсылка();

КонецФункции
 

// Возвращает локализованный заголовок индикатора по его типу и виду объектов учета
&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеИндикатораДинамики(Форма)

	Результат = НСтр("ru='Изменения...'");
	ТипИндикатора    = Форма.ТипИндикатора;
	ВидОбъектовУчета = Форма.ВидОбъектовУчета;
	ВидДенег         = Форма.ВидДенег;
	
	Если ТипИндикатора = "Структура" Тогда
		
		Если ВидОбъектовУчета = "Расходы" Тогда
			
			Если ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.СвободныеДеньги") Тогда
				Результат = НСтр("ru='Расход свободных денег'");
			ИначеЕсли ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.Накопления") Тогда
				Результат = НСтр("ru='Расход накоплений'");
			Иначе
				Результат = НСтр("ru='Расход денег'");
			КонецЕсли;
			
		ИначеЕсли ВидОбъектовУчета = "Доходы" Тогда
			
			Если ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.СвободныеДеньги") Тогда
				Результат = НСтр("ru='Приход свободных денег'");
			ИначеЕсли ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.Накопления") Тогда
				Результат = НСтр("ru='Приход накоплений'");
			Иначе
				Результат = НСтр("ru='Приход денег'");
			КонецЕсли;
			
		ИначеЕсли ВидОбъектовУчета = "ФинансовыеЦели" Тогда
			Результат = НСтр("ru='Структура накоплений'");
		ИначеЕсли ВидОбъектовУчета = "СтатьиБюджета" Тогда
			Результат = НСтр("ru='Структура бюджета'");
		ИначеЕсли ВидОбъектовУчета = "Долги" Тогда
			Результат = НСтр("ru='Структура долгов'");
		КонецЕсли;
		
	ИначеЕсли ТипИндикатора = "Динамика" Тогда
		
		Если ВидОбъектовУчета = "Расходы" Тогда
			
			Если ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.СвободныеДеньги") Тогда
				Результат = НСтр("ru='Динамика расхода свободных денег'");
			ИначеЕсли ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.Накопления") Тогда
				Результат = НСтр("ru='Динамика расхода накоплений'");
			Иначе
				Результат = НСтр("ru='Динамика расходов'");
			КонецЕсли;
			
		ИначеЕсли ВидОбъектовУчета = "Доходы" Тогда
			
			Если ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.СвободныеДеньги") Тогда
				Результат = НСтр("ru='Динамика прихода свободных денег'");
			ИначеЕсли ВидДенег = ПредопределенноеЗначение("ПланСчетов.РазделыУчета.Накопления") Тогда
				Результат = НСтр("ru='Динамика прихода накоплений'");
			Иначе
				Результат = НСтр("ru='Динамика поступлений'");
			КонецЕсли;
			
		ИначеЕсли ВидОбъектовУчета = "ФинансовыеЦели" Тогда
			Результат = НСтр("ru='Динамика накоплений'");
		ИначеЕсли ВидОбъектовУчета = "ДоходыИРасходы" Тогда
			Результат = НСтр("ru='Динамика доходов и расходов'");
		ИначеЕсли ВидОбъектовУчета = "Долги" Тогда
			Результат = НСтр("ru='Динамика долгов'");
		КонецЕсли;
		
	ИначеЕсли ТипИндикатора = "Накопления" Тогда
		
		Если Форма.ВидСрочностиЦели = 0 Тогда
			Результат = НСтр("ru='Накопления на финансовые цели'");
		ИначеЕсли Форма.ВидСрочностиЦели = 1 Тогда
			Результат = НСтр("ru='Срочные финансовые цели'");
		ИначеЕсли Форма.ВидСрочностиЦели = 2 Тогда
			Результат = НСтр("ru='Финансовые цели без срока'");
		Иначе
			
			ТекстЦелей = "";
			Для каждого ЭлементСписка Из Форма.ОтмеченныеЦели Цикл
				Если ЭлементСписка.Пометка Тогда
					ТекстЦелей = ТекстЦелей + ?(ТекстЦелей = "", "", ", ") 
							+ ДеньгиКлиентСервер.СокращенноеПредставление(ЭлементСписка.Значение, 20, Ложь);
				КонецЕсли;
			КонецЦикла;
			
			Если ЗначениеЗаполнено(ТекстЦелей) Тогда
				Результат = НСтр("ru='Накопления'") + ": " + ТекстЦелей;
			Иначе
				Результат = НСтр("ru='Накопления на финансовые цели'");
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипИндикатора = "КурсыВалют" Тогда
		
		Результат = НСтр("ru='Курсы валют'");
		ТекстВалют = "";
		Для каждого ЭлементСписка Из Форма.ОтмеченныеВалюты Цикл
			Если ЭлементСписка.Пометка Тогда
				ТекстВалют = ТекстВалют + ?(ТекстВалют = "", "", ", ") + ЭлементСписка.Значение;
			КонецЕсли;
		КонецЦикла;
		
		Если ТекстВалют <> "" Тогда
			Результат = Результат + " " + ТекстВалют;
		КонецЕсли;
		
	ИначеЕсли ТипИндикатора = "ВводОпераций" Тогда
		
		Результат = НСтр("ru='Ввод операций'");
		
	ИначеЕсли ТипИндикатора = "Планы" Тогда
		
		Результат = НСтр("ru='Планы'");
		
	ИначеЕсли ТипИндикатора = "Бюджет" Тогда
		
		Если Форма.ТипРазделаБюджета = 1 Тогда
			Результат = НСтр("ru='Бюджет %1'");
			Результат = СтрШаблон(Результат, Строка(Форма.ФинансоваяЦельБюджета));
		ИначеЕсли Форма.ТипРазделаБюджета = 1 Тогда
			Результат = НСтр("ru='Сводный бюджет'");
		Иначе
			Результат = НСтр("ru='Бюджет свободных денег'");
		КонецЕсли;
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции


#КонецОбласти
