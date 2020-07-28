﻿//////////////////////////////////////////////////////////////////////////////// 
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

// Функция возвращает список значений, содержащий имена и представления вариантов стандартного периода
//
// Параметры:
//	Нет.
// 
// Возвращаемое значение:
//	СписокЗначений	- Список, который содержит имена и представления вариантов стандартного периода
// 
Функция ПериодПолучитьСписокВыбора() Экспорт
	ТипыПериодов = Новый СписокЗначений;
	ТипыПериодов.Добавить("НеВыбран", НСтр("ru = 'Без ограничения'"));
	ТипыПериодов.Добавить("ПроизвольныйПериод", НСтр("ru = 'Произвольный период'"));
	ТипыПериодов.Добавить("Сегодня", НСтр("ru = 'Сегодня'"));
	ТипыПериодов.Добавить("Вчера", НСтр("ru = 'Вчера'"));
	ТипыПериодов.Добавить("ПрошлаяНеделя", НСтр("ru = 'Прошлая неделя'"));
	ТипыПериодов.Добавить("ЭтаНеделя", НСтр("ru = 'Эта неделя'"));
	ТипыПериодов.Добавить("ПрошлыйМесяц", НСтр("ru = 'Прошлый месяц'"));
	ТипыПериодов.Добавить("ЭтотМесяц", 	НСтр("ru = 'Этот месяц'"));
	ТипыПериодов.Добавить("ПрошлыйКвартал", НСтр("ru = 'Прошлый квартал'"));
	ТипыПериодов.Добавить("ЭтотКвартал", НСтр("ru = 'Этот квартал'"));
	ТипыПериодов.Добавить("ПрошлыйГод", НСтр("ru = 'Прошлый год'"));
	ТипыПериодов.Добавить("ЭтотГод", НСтр("ru = 'Этот год'"));
	Возврат ТипыПериодов;
КонецФункции // ПериодПолучитьСписокВыбора()

// Функция возвращает массив дат по календарю на год; используется как вспомогательная для ускорения вычислений даты по календарю
//
Функция ПолучитьСоответствиеДатПоКалендарюНаГод(Календарь, Год) Экспорт
	Если Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	СоответствиеРезультат = Новый Соответствие();
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика,
	|	КалендарныеГрафики.ДеньВключенВГрафик КАК ДеньВключенВГрафик
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.Год = &Год
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|");
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("Год", Год);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СоответствиеРезультат.Вставить(НачалоДня(Выборка.ДатаГрафика), Выборка.ДеньВключенВГрафик);
	КонецЦикла;
	
	Возврат СоответствиеРезультат;
	
КонецФункции

Функция ЭтоУправлениеНебольшойФирмой() Экспорт
	
	ИмяКонфигурацииВерхнийРегистр = ВРег(Метаданные.Имя);
	
	ЭтоУправлениеНебольшойФирмой = ?(СтрНайти(ИмяКонфигурацииВерхнийРегистр, "УПРАВЛЕНИЕНЕБОЛЬШОЙФИРМОЙ") = 1, Истина, Ложь);
	
	Возврат ЭтоУправлениеНебольшойФирмой;
	
КонецФункции

////////////////////////////////////////////////////////////
// Перенесенные в типовой УНФ на клиент

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().
Функция ПараметрыРаботыКлиента() Экспорт
	
	//ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	//ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы();
	
	СвойстваКлиента = Новый Структура;
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	СвойстваКлиента.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	СвойстваКлиента.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте",
		ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Возврат СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента);
	
КонецФункции
