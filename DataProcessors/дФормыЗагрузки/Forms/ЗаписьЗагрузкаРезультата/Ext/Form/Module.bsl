﻿
&НаКлиенте
Процедура ПеренестиВЗапись(Команда)
	
	Закрыть(ПодготовитьРезультатКПереносуВЗапись(ВладелецФормы.УникальныйИдентификатор));
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьРезультатКПереносуВЗапись(ИДВладельца)

	АдресТаблицы = ПоместитьВоВременноеХранилище(Результаты.Выгрузить(), ИДВладельца);
	Результат = Новый Структура("АдресТаблицыВыбора", АдресТаблицы);
	
	Возврат Результат;

КонецФункции


&НаКлиенте
Процедура СписокИсторииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборСтрокиСпискаИстории();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРезультатВСписок(СтруктураВыбора)

	НоваяСтрока 				= Результаты.Добавить();
	Для каждого СтруктураВыбораСтрока Из СтруктураВыбора Цикл
	
		НоваяСтрока[СтруктураВыбораСтрока.Ключ] = СтруктураВыбораСтрока.Значение;
	
	КонецЦикла; 
	//НоваяСтрока.ИмяРезультата 	= СтруктураВыбора.ИмяРезультата;
	//НоваяСтрока.Параметр        = СтруктураВыбора.Параметр;
	//НоваяСтрока.Значение        = СтруктураВыбора.Значение;
	
	Элементы.ФормаПеренестиВЗапись.Доступность = Результаты.Количество() > 0;

КонецПроцедуры

&НаКлиенте
Процедура ВыборСтрокиСпискаИстории()

	ТекущаяСтрока = Элементы.СписокИстории.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрВыбора = Новый Структура("Время, ИмяРезультата, Параметр, Значение", 
		ТекущаяСтрока.Время, ТекущаяСтрока.ИмяРезультата, ТекущаяСтрока.Параметр, ТекущаяСтрока.Значение);
	
	ДобавитьРезультатВСписок(ПараметрВыбора);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	дфРезультаты = ДанныеФормыВЗначение(Результаты, Тип("ТаблицаЗначений"));
	
	ЗаполнитьЗаголовкиКолонокТабличногоДокумента(дфРезультаты.Колонки);
	
	УсловноеОформлениеВажности();
	УсловноеОформлениеВидаЗаписи();
	
КонецПроцедуры

//	пКолонки - КоллекцияКолонокТаблицыЗначений - Напр., ТЗ.Колонки
&НаСервере
Функция ЗаполнитьЗаголовкиКолонокТабличногоДокумента(пКолонки)

	лНомерТекущейКолонки = 0;
	Для каждого лКолонка Из пКолонки Цикл
	
		лНомерТекущейКолонки 			= лНомерТекущейКолонки + 1;
		
		//Получаем ячейки с данными
		лТабличныйДокументЯчейка 		= ТабличныйДокумент.Область("R1" + "C" + Строка(лНомерТекущейКолонки));
		
		//Заполняем заголовки колонок
		лТабличныйДокументЯчейка.Текст = лКолонка.Имя;
		лТабличныйДокументЯчейка.Шрифт = Новый Шрифт(,, Истина);
	
	КонецЦикла; 

КонецФункции // ЗаполнитьЗаголовкиКолонокТабличногоДокумента()
 

&НаСервере
Процедура УсловноеОформлениеВажности()

	//ПрименитьУсловноеОфомление("Важность", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВажность.Обычное	, "Дата", "Важность_Обычное",, WebЦвета.НейтральноЗеленый);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "Важность", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВажность.Важное	, "Период", "Важность_Важное",, WebЦвета.Оранжевый);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "Важность", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВажность.Особое	, "Период", "Важность_Особое",, WebЦвета.БледноБирюзовый);
	
КонецПроцедуры

&НаСервере
Процедура УсловноеОформлениеВидаЗаписи()

	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "ВидЗаписи", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВидЗаписи.Обычный	, "Дата", "ВидЗаписи_Обычный",, WebЦвета.Лосось);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "ВидЗаписи", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВидЗаписи.Личный	, "ИмяЭмоции", "ВидЗаписи_Личный",, WebЦвета.БледноКрасноФиолетовый);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "ВидЗаписи", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВидЗаписи.Рабочий	, "ИмяЭмоции", "ВидЗаписи_Рабочий",, WebЦвета.ПесочноКоричневый);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "ВидЗаписи", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВидЗаписи.Общий	, "ИмяЭмоции", "ВидЗаписи_Общий",, WebЦвета.СветлоНебесноГолубой);
	//дОбщиеФункцииСервер.ПрименитьУсловноеОфомление(СписокИстории.УсловноеОформление.Элементы, "ВидЗаписи", ВидСравненияКомпоновкиДанных.Равно, Перечисления.дВидЗаписи.Прочее	, "ИмяЭмоции", "ВидЗаписи_Прочее",, WebЦвета.БледноЗолотистый);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Результаты.Количество() > 0 Тогда
		Ответ = Вопрос("В итоговой таблице уже есть строки. Очистить их?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, "Проверка заполнения табличной части");
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Результаты.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ПрочитатьДанныеТабличногоДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеТабличногоДокумента()
	
	лДанныеТабличногоДокумента = Новый ТаблицаЗначений;
	
	//Получаем колонки
	лСтруктураДанных 	= Новый Структура();
	НомерТекущейКолонки = 0;
	Для лНомерТекущейКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
		
		//Получаем ячейки с данными
		лТабличныйДокументЯчейка 	= ТабличныйДокумент.Область("R1" + "C" + Строка(лНомерТекущейКолонки));
		
		//Заполняем структуру колонок и их номеров
		лСтруктураДанных.Вставить(лТабличныйДокументЯчейка.Текст, лНомерТекущейКолонки);
		
	КонецЦикла;
	
	//Заполняем ТаблицуЗначений данными из ТабличногоДокумента
	Для лНомерТекущейСтроки = 2 По ТабличныйДокумент.ВысотаТаблицы Цикл //лНомерТекущейСтроки = 1 это имена колонок
		
		НоваяСтрока 				= Результаты.Добавить();
		лУстановитьТипПараметра 	= Неопределено;
		Для каждого лСтруктураДанныхЭлем Из лСтруктураДанных Цикл
			
			//Получаем ячейки с данными из ТабличногоДокумента: 
			//лСтруктураДанныхЭлем.Ключ = Имя колонки
			//лСтруктураДанныхЭлем.Значение = Номен колонки
			лТабличныйДокументЯчейка 	= ТабличныйДокумент.Область("R" + Формат(лНомерТекущейСтроки, "ЧГ=") + "C" + Строка(лСтруктураДанныхЭлем.Значение));
			
			лИмяКолонки 		= лСтруктураДанныхЭлем.Ключ;
			лЗначениеКолонки 	= лТабличныйДокументЯчейка.Текст;
			
			Если ЗначениеЗаполнено(лЗначениеКолонки) Тогда
				Если лИмяКолонки = "Время" Тогда
					лЗначениеКолонки = СтрЗаменить(лЗначениеКолонки, ":", "");
					Если СтрДлина(лЗначениеКолонки) = 2 Тогда
						лЗначениеКолонки = лЗначениеКолонки + "00";
					ИначеЕсли СтрДлина(лЗначениеКолонки) = 3 Тогда
						лЗначениеКолонки = лЗначениеКолонки + "0";
					КонецЕсли; 
					
					Попытка
					
						лЗначениеКолонки = Дата("00010101" + лЗначениеКолонки);	
					
					Исключение
						Сообщить("При записи в колонку Время ошибка: " + ОписаниеОшибки());
					КонецПопытки;
				ИначеЕсли лИмяКолонки = "ИмяРезультата" Тогда
					лЗначениеКолонки = Справочники.дРезультат.НайтиПоНаименованию(лЗначениеКолонки);
				ИначеЕсли лИмяКолонки = "Параметр" Тогда
					лМассивПодбораПараметра = Новый Массив;
					лМассивПодбораПараметра.Добавить("дВидыДеятельности");
					лМассивПодбораПараметра.Добавить("дРезультат");
					лМассивПодбораПараметра.Добавить("дТеги");
					лМассивПодбораПараметра.Добавить("дЭмоции");
					лМассивПодбораПараметра.Добавить("дВопросы");
					лМассивПодбораПараметра.Добавить("Контакты"); //Не входит в 1С:ДИД. Желательно проверить по метаданным
					
					Для каждого лЭлементПодбораПараметра Из лМассивПодбораПараметра Цикл
						
						Если лЭлементПодбораПараметра = "Контакты" Тогда
							лЗначениеКолонкиКонтакты = дОбщиеФункцииСервер.ПроверитьПолучитьСправочникПустаяСсылка(лЭлементПодбораПараметра);
							Если лЗначениеКолонкиКонтакты <> Неопределено Тогда
								лЗначениеКолонки = лЗначениеКолонкиКонтакты;
								Продолжить;
							КонецЕсли;
						КонецЕсли;
						
						лПодборЗначениеКолонки 	= Справочники[лЭлементПодбораПараметра].НайтиПоНаименованию(лЗначениеКолонки);
						Если ЗначениеЗаполнено(лПодборЗначениеКолонки) Тогда
							лЗначениеКолонки 	= лПодборЗначениеКолонки;
							
							лРезультатПараметрТип = ТипЗнч(лЗначениеКолонки);
							Если лРезультатПараметрТип = Тип("СправочникСсылка.дВидыДеятельности") Тогда
								лУстановитьТипПараметра = лЗначениеКолонки.ТипЗначенияРезультата;
								//НоваяСтрока["Значение"] = лУстановитьТипПараметра;
							КонецЕсли;	
							
							Прервать;
						КонецЕсли; 
						
					КонецЦикла;
				ИначеЕсли лИмяКолонки = "Значение" Тогда //Проверим тип, полученный из Параметра
					Если лУстановитьТипПараметра <> Неопределено Тогда
						Попытка
						
							Если ТипЗнч(лУстановитьТипПараметра) = Тип("Число") Тогда
								лЗначениеКолонки 	= Число(лЗначениеКолонки);
							ИначеЕсли ТипЗнч(лУстановитьТипПараметра) = Тип("Строка") Тогда
								лЗначениеКолонки 	= Строка(лЗначениеКолонки);	
							ИначеЕсли ТипЗнч(лУстановитьТипПараметра) = Тип("Дата") Тогда
								лЗначениеКолонки 	= Дата(лЗначениеКолонки);
							ИначеЕсли ТипЗнч(лУстановитьТипПараметра) = Тип("Булево") Тогда
								лЗначениеКолонки 	= Булево(лЗначениеКолонки);
							КонецЕсли;	
						
						Исключение
							
							Сообщить("При записи в колонку Значение ошибка: " + ОписаниеОшибки());
						
						КонецПопытки; 
						 
					КонецЕсли;	
				КонецЕсли;
			КонецЕсли;
			
			//Заполняем итоговую таблицу значений данными из ТабличногоДокумента
			НоваяСтрока[лИмяКолонки] = лЗначениеКолонки;
		
		КонецЦикла; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыПараметрПриИзменении(Элемент)
	
	//лРезультатТекущиеДанные = Элементы.Результаты.ТекущиеДанные;
	//Если лРезультатТекущиеДанные = Неопределено Тогда
	//	Возврат;	
	//КонецЕсли;
	//
	//// Обрабатываем Вид Деятельности
	//лРезультатТекущиеДанныеПараметр 	= лРезультатТекущиеДанные.Параметр;
	//Если ЗначениеЗаполнено(лРезультатТекущиеДанныеПараметр) Тогда
	//	// Заполняем тип параметра
	//	лРезультатПараметрТип 			= ТипЗнч(лРезультатТекущиеДанныеПараметр);
	//	Если лРезультатПараметрТип = Тип("СправочникСсылка.дВидыДеятельности") Тогда
	//		лРезультатТекущиеДанныеЗначение 	= лРезультатТекущиеДанные.Значение; 
	//		Если НЕ ЗначениеЗаполнено(лРезультатТекущиеДанныеЗначение) Тогда // И если текущее значение не заполнено, иначе затрём
	//			ТипЗначенияРезультатаВидаДеятельности 		= ПолучитьТипЗначенияРезультатаВидаДеятельности(лРезультатТекущиеДанныеПараметр);	
	//			Элементы.Результат.ТекущиеДанные.Значение 	= ТипЗначенияРезультатаВидаДеятельности;
	//		КонецЕсли; 
	//		
	//		// Заполняем теги
	//		ЗаполнитьТегиНаСервере(лРезультатТекущиеДанныеПараметр);
	//		
	//		ПересчитатьТеги();
	//		
	//	КонецЕсли;	
	//КонецЕсли;
	
КонецПроцедуры
