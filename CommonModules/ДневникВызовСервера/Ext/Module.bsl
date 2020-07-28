﻿////////////////////////////////////////////////////////////////////////////////
// ДеньгиВызовСервера: Общий фунционал конфигурации 1С:Деньги
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает и очищает параметр, передаваемый в форму, открытую по навигационной ссылке
Функция ПолучитьПараметрПереходаПоСсылке() Экспорт

	Попытка
		
		Если ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке <> "" Тогда
			Результат = ПолучитьИзВременногоХранилища(ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке);
			ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке = "";
			Возврат Результат;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	
	Исключение
		
		// Запись в журнал регистрации не требуется
		ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке = "";
		Возврат Неопределено;
		
	КонецПопытки; 

КонецФункции

// Сохраняет параметр для передачи в форму, открываемую по навигационной ссылке
Функция ЗаписатьПараметрПереходаПоСсылке(Параметры) Экспорт

	Попытка
	
		ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке = ПоместитьВоВременноеХранилище(Параметры);
		Возврат ПараметрыСеанса.ПараметрыПереходаПоНавигационнойСсылке;
	
	Исключение
		
		// Запись в журнал регистрации не требуется
		Возврат Неопределено;
		
	КонецПопытки; 

КонецФункции

// Изменяет настройки стандартного интерфейса: на начальной странице открывает указанную в параметрах форму, 
//	при необходимости скрывает панели
//
//Параметры:
//	ИмяФормы - Строка - полное иня формы, которую нужно открыть на начальной странице
//	СкрыватьПанели - Булево - нужно ли убирать панели?
//
Процедура УстановитьИнтерфейсПриложенияПоФорме(ИмяФормы, СкрыватьПанели = Истина) Экспорт
	
	Если СкрыватьПанели Тогда
		Настройки = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
		НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		Настройки.УстановитьСостав(НастройкиСостава);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", "", Настройки);
	КонецЕсли;
	
	НачальнаяСтраница = Новый НастройкиНачальнойСтраницы;
	СоставФорм = Новый СоставФормНачальнойСтраницы;
	СоставФорм.ЛеваяКолонка.Добавить(ИмяФормы);
	НачальнаяСтраница.УстановитьСоставФорм(СоставФорм);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", "", НачальнаяСтраница);
	
КонецПроцедуры

// Настраивает пользовательский интерфейс по умолчанию: панели, начальная страница и т.д.
//
//Параметры:
//	нет
//
Процедура УстановитьСтандартныйИнтерфейс() Экспорт
	
	// Натройка панелей
	Настройки = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
	НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
	
	// Вверху группируем панель инструментов и функции открытого раздела
	Верх = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
	Верх.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельФункцийТекущегоРаздела"));
	Верх.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельИнструментов"));
	НастройкиСостава.Верх.Добавить(Верх);
	
	// Внизу размещаем панель открытых
	НастройкиСостава.Низ.Очистить();
	НастройкиСостава.Низ.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельОткрытых"));
	
	// По сторонам ничего нет
	НастройкиСостава.Лево.Очистить();
	НастройкиСостава.Право.Очистить();
	
	// Записываем настройки панелей
	Настройки.УстановитьСостав(НастройкиСостава);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", "", Настройки);
	
	// Настройки интерфейса
	НастройкиИнтерфейса = Новый НастройкиКомандногоИнтерфейса();
	НастройкиИнтерфейса.ОтображениеПанелиРазделов = Вычислить("ОтображениеПанелиРазделов.Текст");
	ХранилищеСистемныхНастроек.Сохранить("Общее/ПанельРазделов/НастройкиКомандногоИнтерфейса", "", НастройкиИнтерфейса);
	
	// Состав начальной страницы
	НачальнаяСтраница = Новый НастройкиНачальнойСтраницы;
	СоставФорм = Новый СоставФормНачальнойСтраницы;
	
	СоставФорм.ЛеваяКолонка.Добавить("Обработка.НачальнаяСтраница.Форма.Обзор");
	НачальнаяСтраница.УстановитьСоставФорм(СоставФорм);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", "", НачальнаяСтраница);
	
КонецПроцедуры

// Проверяет наличие начальных настроеки для пользователя информационной базы.
//
// Параметры:
//  Отказ - Булево - возможность продолжать работу. Устанавливается в Истина, если настройки изменились и для их применения требуется перезагрузить программу.
//  ПовторитьПринудительно - Булево - позволяет повторно применить настройки, даже если они уже применялись ранее.
//  ОбновлятьИнтерфейс - Булево - Возвращаемый параметр, в который устанавливается признак необходимости обновить интерфейс
//
Процедура ПроверитьНачальныеНастройкиИнтерфейса(Отказ, ПовторитьПринудительно = Ложь, ОбновлятьИнтерфейс = Ложь) Экспорт
	
	ОбновлятьИнтерфейс = Ложь;
	
	// Проверяем, выполнялась ли настройка
	ИмяКонтрольногоПараметра = "Общее/НачальныеНастройкиИнтерфейсаВыполнены/Версия838";
	НачальныеНастройкиПрименены = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяКонтрольногоПараметра, "", Ложь);
	Если НачальныеНастройкиПрименены = Истина И ПовторитьПринудительно <> Истина Тогда
		Возврат; // Настройки уже применены, принудительно сбрасывать их не требуется
	КонецЕсли; 
		
	// Опредеяем текущий вариант интерфейса. Переключение на другой вариант возможно только после перезагрузки (Отказ устанавливается в Истина)
	ПравильныйВариантИнтерфейса = Вычислить("ВариантИнтерфейсаКлиентскогоПриложения.Такси");
	ТекущиеНастройкиКлиента = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Общее/НастройкиКлиентскогоПриложения", "", Неопределено);
	Если ТекущиеНастройкиКлиента = Неопределено ИЛИ ТекущиеНастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения <> ПравильныйВариантИнтерфейса Тогда
		Отказ = Истина; // Приложение будет перезагружено
	КонецЕсли; 
		
	// Делаем отметку о применении настроек
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(ИмяКонтрольногоПараметра, "", Истина);
	
	// Настраиваем отображение панелей и режимы приложения
	НастройкиКлиента = Новый НастройкиКлиентскогоПриложения();
	НастройкиКлиента.ОтображатьПанелиНавигацииИДействий = Ложь;
	НастройкиКлиента.ОтображатьПанельРазделов = Ложь;
	НастройкиКлиента.РежимОткрытияФормПриложения  = РежимОткрытияФормПриложения.Закладки;
	НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ПравильныйВариантИнтерфейса;
		
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения", "", НастройкиКлиента);
		
	// Устанавливаем настройку по умолчанию для панелей и начальной страницы
	ОбновлятьИнтерфейс = Истина;
	Если ОбщегоНазначенияДневник.ИнформационнаяБазаПустая() Тогда
		УстановитьИнтерфейсПриложенияПоФорме("Обработка.ПомощникНачалаРаботы.Форма", Истина);
	Иначе
		УстановитьСтандартныйИнтерфейс();
	КонецЕсли;
	
	// Сохраняем настройки с ключем БСП для корректной обработки первого запуска
	КлючОбъекта         = "Общее/НастройкиНачальнойСтраницы";
	КлючОбъектаХранения = "Общее/НастройкиНачальнойСтраницыПередОчисткой";
	ТекущиеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта);
	ТекущиеНастройки = Новый ХранилищеЗначения(ТекущиеНастройки);
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъектаХранения, "", ТекущиеНастройки);
	
КонецПроцедуры

// Устарела. Оставлена для совместимости с регламентированной отчетностью
//	Следует использовать ОбщегоНазначения.ЗначениеРеквизитаОбъекта()
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);

КонецФункции
 
// Возвращает список значений с видами операций. 
//	Используется для выбора вида операции перед их добавлением, для установки отборов и т.п.
//
//Параметры:
//	ВключаемыеВиды - Массив или Неопределено - содержит строки, которые нужно добавить в список. 
//			Если неопределено, добавляются все виды операций
//	ИсключаемыеВиды - Массив или Неопределено - содержит строки, которые нужно исключить из списка. 
//			Если неопределено, добавляются все виды операций. При наличии вида операции в обоих массивах одновременно
//			вид операции будет исключен
//
//
Функция ПолучитьСписокВидовОпераций(Знач ВключаемыеВиды = Неопределено, Знач ИсключаемыеВиды = Неопределено) Экспорт

	Если ТипЗнч(ВключаемыеВиды) = Тип("Строка") Тогда
		ВключаемыеВиды = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(ВключаемыеВиды, ",");
	КонецЕсли;
	Если ТипЗнч(ИсключаемыеВиды) = Тип("Строка") Тогда
		ИсключаемыеВиды = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(ИсключаемыеВиды, ",");
	КонецЕсли;
	
	Возврат ОбщегоНазначенияДневник.ПолучитьСписокВидовОпераций(ВключаемыеВиды, ИсключаемыеВиды);
	
КонецФункции

// Добавляет в журнал регистрации запись об ошибке, возникшей при выполнении указанного действия. Заполняет ТекстСообщенияПользователю
//	информацией, достаточной для понимания пользователем
//
//Параметры:
//	КлючЗаписиЖурнала - Строка - ключ регистрируемых событий. Например, "Обмен с мобильным приложением", "Обновление информационной базы"
//	Действие - Строка - краткое название выполняемого действия, при котором возникла ошибка
//	ИнформацияОбОшибке - ИнформацияОбОшибке или строка - подробности, которые нужно сообщить пользователю и записать в журнал регистрации
//	Отказ - Булево (не обязательно, по умолчнанию Ложь) - возращаемый параметр
//	ТекстСообщенияПользователю - Строка (не обязательно, по умолчнанию "") - возращаемый параметр, сообщение для показа пользователю
//
//Пример использования:
//	Ключ = "Загрузка данных из файла";
//	
//	Попытка
//	
//		Действие = "Чтение файла";
//		Чтение = Новый ЧтениеФайла(ИмяФайла);
//		текст = Чтение.Прочитать();
//
//		Действие = "Удаление файла";
//		УдалитьФайлы(ИмяФайла);
//	
//	Исключение
//
//		ДеньгиВызовСервера.ЗаписатьОшибкуДействияВЖурналРегистрации(Ключ, Действие, ИнформацияОбОшибке());
//
//	КонецПопытки
//
Процедура ЗаписатьОшибкуДействияВЖурналРегистрации(КлючЗаписиЖурнала, Действие, ИнформацияОбОшибке, Отказ = Ложь, ТекстСообщенияПользователю = "") Экспорт


	Отказ = Истина;
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		КраткаяИнформация = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ПолнаяИнформация  = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	Иначе
		КраткаяИнформация = ИнформацияОбОшибке;
		ПолнаяИнформация  = ИнформацияОбОшибке;
	КонецЕсли; 
	
	ТекстСообщенияПользователю = НСтр("ru = 'Ошибка при выполнении действия'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ТекстСообщенияПользователю = ТекстСообщенияПользователю + ": " + Действие + Символы.ПС + КраткаяИнформация;
	
	ЗаписьЖурналаРегистрации(КлючЗаписиЖурнала,
				УровеньЖурналаРегистрации.Ошибка,,,
				Действие + ?(Действие = "", "", ":" + Символы.ПС) + ПолнаяИнформация);


КонецПроцедуры

// Изменяет пометку удаления для объекта по указанной ссылке
//	
//Параметры:
//	СсылкаНаОбъект - ссылка на элемент справочника или документ
//	
Процедура ИзменитьПометкуУдаленияОбъектаПоСсылке(СсылкаНаОбъект) Экспорт
	
	Объект = СсылкаНаОбъект.ПолучитьОбъект();
	
	Если ОбщегоНазначения.ЭтоСправочник(Объект.Метаданные()) Тогда
		
		Если Метаданные.ПодпискиНаСобытия.ПроверкаАктивностиЭлементовСправочников.Источник.СодержитТип(ТипЗнч(Объект)) Тогда
			// Для этих объектов рекурсивное изменение пометки удаления выполняется в подписке на событие
			ВключаяПодчиненные = Ложь;
		Иначе
			ВключаяПодчиненные = Истина;
		КонецЕсли;
		
		Объект.УстановитьПометкуУдаления(НЕ Объект.ПометкаУдаления, ВключаяПодчиненные);
		
	Иначе
		
		Объект.УстановитьПометкуУдаления(НЕ Объект.ПометкаУдаления);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет автоматическую проверку предела планирования и, при необходимости, сдвигает его до конца следующего года
Процедура ПроверитьПределПланирования() Экспорт
	
	ПределПланирования = Константы.ПределПланирования.Получить();
	Если НачалоМесяца(ПределПланирования) <= НачалоМесяца(ТекущаяДата()) Тогда
		НовыйПредел = КонецГода(ДобавитьМесяц(ТекущаяДата(), 12));
		Константы.ПределПланирования.Установить(НовыйПредел);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие на форме элемента с указанным именем и изменяет значения его свойств
//
//Параметры:
//	Форма - УправляемаяФорма, на которой нужно найти элемент
//	ИмяЭлемента - Строка - имя изменяемого элемента
//	СтруктраСвойств - Структура с ключами именами свойств элемента и их значениями
//
Процедура ИзменитьСвойстваЭлементаФормы(Форма, ИмяЭлемента, СтруктураСвойств) Экспорт
	
	Элемент = Форма.Элементы.Найти(ИмяЭлемента);
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из СтруктураСвойств Цикл
		Если Элемент[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
			Элемент[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Получает из обработки указанный макет и распаковывает его по указанному адресу
//
//Параметры:
//	КаталогИнструкций - Строка - полное имя каталога, в который нужно распаковать макет обработки
//	ИмяМакета    - Строка - имя макета открываемой инструкции
//	ИмяОбработки - Строка - имя обработки, из которой нужно получить макет
//
//Возвращаемое значение:
//	Строка или Неопределено - полное имя файла инструкции или пустая строка, если макет не найден - Неопределено
//
Функция РаспаковатьФайлыИнструкции(КаталогИнструкций, ИмяМакета, ИмяОбработки) Экспорт
	
	ЕстьИнструкция = Метаданные.Обработки[ИмяОбработки].Макеты.Найти(ИмяМакета) <> Неопределено;
	Если Не ЕстьИнструкция Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбъектОбработки = Обработки[ИмяОбработки].Создать();
	
	Архив = ОбъектОбработки.ПолучитьМакет(ИмяМакета);
	
	ИмяВремФайла = ПолучитьИмяВременногоФайла("tmp");
	Архив.Записать(ИмяВремФайла);
	
	ЧтениеАрхива = Новый ЧтениеZipФайла(ИмяВремФайла);
	ЧтениеАрхива.ИзвлечьВсе(КаталогИнструкций, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	
	РазделительПути = ПолучитьРазделительПутиКлиента();
	Файл = Новый Файл(КаталогИнструкций + РазделительПути + ИмяМакета + РазделительПути + ИмяМакета + ".htm");
	Если Файл.Существует() И Файл.ЭтоФайл() Тогда
		Возврат Файл.ПолноеИмя;
	КонецЕсли; 
	
	Возврат "";
	
КонецФункции


#КонецОбласти







