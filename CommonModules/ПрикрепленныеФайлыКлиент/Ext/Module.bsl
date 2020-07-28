﻿//////////////////////////////////////////////////////////////////////////////////////////
// Интерфейс работы с прикрепленными файлами на мобильном устройстве (клиент)
// 
//////////////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Возвращает имя события сделанной фотографии/исполненной аудиозаписи, для использования в событии ОбработкаОповещения
// 
// Возвращаемое значение:
//  Строка - Имя события
//
Функция ИмяСобытияПрикреплениеФайла() Экспорт
	
	Возврат "ДобавлениеПрикрепленногоФайла";
	
КонецФункции

// Возвращает имя события сделанной фотографии/исполненной аудиозаписи, для использования в событии ОбработкаОповещения
// 
// Возвращаемое значение:
//  Строка - Имя события
//
Функция ИмяСобытияУдалениеФайла() Экспорт
	
	Возврат "УдалениеПрикрепленногоФайла";
	
КонецФункции

// Возвращает имя события сделанной фотографии/исполненной аудиозаписи, для использования в событии ОбработкаОповещения
// 
// Возвращаемое значение:
//  Строка - Имя события
//
Функция ИмяСобытияИзменениеСпискаМультимедиа() Экспорт
	
	Возврат "ИзменениеСпискаМультимедиа";
	
КонецФункции

// Проверяет пришедшее событие на генерацию мультимедиа данных для текущей формы
//
// Параметры:
//  ЭтаФорма	 - УправляемаяФорма - контекст текущей формы
//  ИмяСобытия	 - Строка - Имя текущего события
//  Параметр	 - Произвольный - Параметр события
//  Источник	 - Произвольный - Источник события
// 
// Возвращаемое значение:
//  Истина - если событие есть генерация мультимедиа для текущей формы
//
Функция ЭтоПрикреплениеФайла(ЭтаФорма, ИмяСобытия, Источник) Экспорт
	Возврат (ИмяСобытия = ИмяСобытияПрикреплениеФайла()) И (Источник = ЭтаФорма);
КонецФункции

// Проверяет пришедшее событие на генерацию мультимедиа данных для текущей формы
//
// Параметры:
//  ЭтаФорма	 - УправляемаяФорма - контекст текущей формы
//  ИмяСобытия	 - Строка - Имя текущего события
//  Параметр	 - Произвольный - Параметр события
//  Источник	 - Произвольный - Источник события
// 
// Возвращаемое значение:
//  Истина - если событие есть генерация мультимедиа для текущей формы
//
Функция ЭтоИзменениеСпискаМультимедиа(ЭтаФорма, ИмяСобытия, Источник) Экспорт
	Возврат (Источник = ЭтаФорма)
		И (ИмяСобытия = ИмяСобытияИзменениеСпискаМультимедиа() Или ИмяСобытия = ИмяСобытияУдалениеФайла());
КонецФункции

// Проверяет - является ли прикрепленный файл изображением
//
// Параметры:
//  СпособОткрытия	 - Перечисление.СпособОткрытияПрикрепленногоФайла - Способ открытия текущего прикрепленного файла
// 
// Возвращаемое значение:
//  Булево - Истина, если прикрепленный файл является изображением
//
Функция ЭтоИзображение(СпособОткрытия) Экспорт
	
	Возврат СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакИзображение");
	
КонецФункции

// Проверяет - является ли прикрепленный файл аудиофайлом
//
// Параметры:
//  СпособОткрытия	 - Перечисление.СпособОткрытияПрикрепленногоФайла - Способ открытия текущего прикрепленного файла
// 
// Возвращаемое значение:
//  Булево - Истина, если прикрепленный файл является аудиофайлом
//
Функция ЭтоАудиоФайл(СпособОткрытия) Экспорт
	
	Возврат СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакАудиоФайл");
	
КонецФункции

// Воспроизводит медиа в зависимоти от его типа
//
// Параметры:
//	Адрес	- Расположение данных во временном хранилище или в информационной базе
//	СпособОткрытия - ПеречислениеСсылка.СпособОткрытияПрикрепленногоФайла
//	Расширение - Строка - расширение файла
//	Наименование - Строка - наименоваение файла
//
Процедура ВоспроизвестиФайл(ОписаниеФайла) Экспорт
	
	Если ПустаяСтрока(ОписаниеФайла.ИмяФайла) Тогда
		ОписаниеФайла.ИмяФайла = ВыгрузитьДанныеВФайл(ОписаниеФайла.НавигационнаяСсылка, ОписаниеФайла.Расширение, ОписаниеФайла.Наименование);
	КонецЕсли;
	
	Если ОписаниеФайла.ИмяФайла = "" Тогда
		Сообщить(НСтр("ru='Не получилось выгрузить данные в файл'"));
	Иначе
		ОткрытьФайлПриложением(ОписаниеФайла.ИмяФайла, ОписаниеФайла.СпособОткрытия, ОписаниеФайла.Расширение);	
	КонецЕсли;
	
КонецПроцедуры

// Обновляет двоичные данные файла
//Если файл открывался в приложении, его имя хранится в ОписанииФайла.ИмяФайла
//Процедура получает двоичные данные этого файла и заменяет ими существующие двоичные данные файла
//
//Параметры:
//	ОписаниеФайла - Структура, заполненная информацией о файле
//	Форма - УправляемаяФорма, из которой вызвана команда обновления
//
//Возвращаемое значение
//	Булево - Истина, если файл обновлен, ложь в другом случае
//
Функция ОбновитьСодержимоеФайла(ОписаниеФайла, Знач Форма = Неопределено) Экспорт
	
	Если ОписаниеФайла = Неопределено Или Не ЗначениеЗаполнено(ОписаниеФайла.ИмяФайла) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Файл = Новый Файл(ОписаниеФайла.ИмяФайла);
	Если Не Файл.Существует() Тогда
		
		ТекстСообщения = НСтр("ru='Файл %1 не найден. Возможно он был удален или перемещен в другое место.'"); 
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОписаниеФайла.ИмяФайла);
		Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		Возврат Ложь;
		
	ИначеЕсли Файл.ЭтоКаталог() Тогда
		
		ТекстСообщения = НСтр("ru='%1 является каталогом а не файлом!'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОписаниеФайла.ИмяФайла);
		Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		Возврат Ложь;
		
	КонецЕсли;
	
	НовыеДанные = СтруктураФайлаПоЕгоИмени(ОписаниеФайла.ИмяФайла, Форма);
	НовыеДанные.Предпросмотр = ПрикрепленныеФайлыКлиентСервер.ПредставлениеФайлаНаФорме(НовыеДанные.СпособОткрытия, НовыеДанные.НавигационнаяСсылка);
	Если НовыеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Не удалось получить данные из файла %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОписаниеФайла.ИмяФайла);
		Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		Возврат Ложь;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ОписаниеФайла, НовыеДанные, "СпособОткрытия,ДатаСоздания,Расширение,Размер,НавигационнаяСсылка,Предпросмотр,Иконка");
	
	Попытка
		УдалитьФайлы(ОписаниеФайла.ИмяФайла);
		ОписаниеФайла.ИмяФайла = "";
	Исключение
		// Обработка исключения не требуется.
		// Если файл остался открытым в приложении, в него могут внести еще изменения
	КонецПопытки; 
	
	Возврат Истина;
	
КонецФункции

// Открывает указанный файл указанным способом: либо в платформе, либо в приложении ОС, назначенным по умолчанию для файлов 
//
//Параметры:
//	ИмяФайла	- Строка - Имя открываемого фала
//	СпособОткрытия	- ПеречислениеСсылка.СпособОткрытияПрикрепленногоФайла 
//	Расширение - Строка - расширение открываемого файла
//
Процедура ОткрытьФайлПриложением(ИмяФайла, СпособОткрытия, Расширение) Экспорт
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакДокументПлатформы")
		Или СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакТекст") Тогда
		
		ОткрытьФайлВПлатформе(ИмяФайла, Расширение);
		
	Иначе
		
		Попытка
			ЗапуститьПриложение(ИмяФайла, , );
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ПоказатьПредупреждение(, СтрШаблон(
				НСтр("ru = 'При открытии файла
				           |""%1""
				           |произошла ошибка:
				           |""%2"".'"),
				ИмяФайла,
				ИнформацияОбОшибке.Описание));
		КонецПопытки; 
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в реквизит Медиафайлы указанной формы новый медиафайл, описанный в структуре 
//
//Параметры:
//	Форма - управляемая форма, в список которой нужно добавить файл
//	ПакетДанных - Структура или СписокЗначений - результат функции ПрикрепленныеФайлыКлиентСервер.НоваяСтруктураПрикрепляемогоФайла()
//
Процедура ДобавитьФайлВСписокФормы(Форма, ПакетДанных) Экспорт
	
	ЕстьМодификация = Ложь;
	Если ТипЗнч(ПакетДанных) = Тип("Структура") Тогда
		ЕстьМодификация = Истина;
		Форма.Медиафайлы.Добавить(ПакетДанных, ПакетДанных.Наименование);
	ИначеЕсли ТипЗнч(ПакетДанных) = Тип("СписокЗначений") Тогда
		Для Каждого Данные Из ПакетДанных Цикл
			СтруктураФайла = Данные.Значение;
			Форма.Медиафайлы.Добавить(СтруктураФайла, СтруктураФайла.Наименование);	
		КонецЦикла;
		ЕстьМодификация = Истина;
	КонецЕсли;
	
	Если ЕстьМодификация Тогда
		ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеМедиафайлов(Форма);
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры


// Отобразить список прикрпленных файлов
//
// Параметры:
//  СписокФайлов - СписокЗначений - список прикрпленных файлов
//
Процедура ОтобразитьСписокПрикрпленныхФайлов(СписокФайлов) Экспорт
	
	Если (СписокФайлов = Неопределено) ИЛИ (СписокФайлов.Количество() = 0) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СписокФайлов", СписокФайлов);
	ОткрытьФорму("РегистрСведений.ПринадлежностьФайлов.Форма.СписокФайловОбъекта", ПараметрыФормы);	
	
КонецПроцедуры

// Получает файл из временного хранилища или из базы данных и сохраняет в локальную файловую систему пользователя.
//
//Параметры:
//	Адрес	- Расположение данных во временном хранилище или в информационной базе
//	Расширение - Строка - расширение файла
//	Наименование - Строка - наименоваение файла
//
//Возвращаемое значение:
//	Строка - Имя файла, в который выгружены медиаланные
//
Функция ВыгрузитьДанныеВФайл(Знач Адрес, Знач Расширение, Знач Наименование) Экспорт

	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяФайла = КаталогВременныхФайлов();
	
	Если Наименование = "" Тогда		
		Наименование = ПрикрепленныеФайлыКлиентСервер.АвтоНаименованиеФайла( Неопределено, ТекущаяДата() );
	КонецЕсли;
	
	Имяфайла = ИмяФайла + ПрикрепленныеФайлыКлиентСервер.НаименованиеБезСлужебныхСимволов(Наименование);
	ИмяФайла = ИмяФайла + ?(Лев(Расширение,1) = ".", "", ".") + Расширение;
	
	Если ПолучитьФайл(Адрес, ИмяФайла, Ложь) Тогда
		Возврат ИмяФайла;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

// Обработчик нажатия на представление файлов
//
// Параметры:
//  Медиафайлы								 - СписокЗначений - Список прикрепленных файлов
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - Имя навигационной ссылки 
//
Процедура ОбработчикНажатияНаПредставлениеФайлов(Форма, СтандартнаяОбработка, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	СтандартнаяОбработка = Ложь;
	КлючОдногоФайла      = "Файл_";
	КлючСсылки           = НавигационнаяСсылкаФорматированнойСтроки;
	Медиафайлы           = Форма.Медиафайлы;
	
	Если КлючСсылки = "Изменить" Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеСпискаПрикрепленныхФайлов", ЭтотОбъект, ДополнительныеПараметры);
		
		ПараметрыФормы = Новый Структура("СписокФайлов, ВладелецФайлов", Медиафайлы, Форма.Объект.Ссылка);
		ОткрытьФорму("РегистрСведений.ПринадлежностьФайлов.Форма.СписокФайловОбъекта", ПараметрыФормы, Форма, Истина, , , Оповещение);	
				
	ИначеЕсли КлючСсылки = "Добавить" Тогда
		
		ДобавитьФайлыВДиалоге(Форма);	
		
	ИначеЕсли СтрНайти(КлючСсылки, КлючОдногоФайла) > 0 Тогда
		
		ИД = Число(СтрЗаменить(КлючСсылки, КлючОдногоФайла, ""));
		
		ТекЭлемент = Медиафайлы.НайтиПоИдентификатору(ИД);
		Если ТекЭлемент <> Неопределено Тогда
			
			ПрикрепленныйФайл = ТекЭлемент.Значение;
			ВоспроизвестиФайл(ПрикрепленныйФайл);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает способ открытия файла по его данным
//
// Параметры:
//  ФайлКакОбъект	 - Файл -  Файл пользователя на диске
// 
// Возвращаемое значение:
//   Перечисление.СпособОткрытияПрикрепленногоФайла - 
//
Функция ПолучитьСпособОткрытияФайла(ФайлКакОбъект) Экспорт
	Расширение = "*" + Нрег(ФайлКакОбъект.Расширение);
	
	Если СтрНайти( ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловКартинок(), Расширение ) > 0 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакИзображение");	
	ИначеЕсли СтрНайти( ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловТекста(), Расширение ) > 0  Тогда
		Возврат ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакТекст");	
	ИначеЕсли СтрНайти( ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловПлатформы(), Расширение ) > 0  Тогда
		Возврат ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакДокументПлатформы");	
	ИначеЕсли СтрНайти( ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловHTML(), Расширение ) > 0  Тогда
		Возврат ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакHTML");	
	КонецЕсли;
	
	Возврат ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.СредствамиОС");
	
КонецФункции

// Добавить файлы к указанному источнику в диалоге
//
// Параметры:
//  Источник - УправляемаяФорма - Форма вызова добавления прикрепленных файлов
//  ВладелецХранилища - УправляемаяФорма или УникальныйИдентификатор - Форма-владелец будущего файла или уникальный идентификатор для сохранения во временном хранилище
//  СпособОткрытия	 - Перечисление.СпособОткрытияПрикрепленногоФайла или Неопределено - Способ открытия выбираемых файлов или неопределено, для полного списка
//
Процедура ДобавитьФайлыВДиалоге(Форма, ВладелецХранилища = Неопределено, СпособОткрытия = Неопределено) Экспорт
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);		
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = ПолучитьФильтрДляДиалогаВыбораФайлов(СпособОткрытия);
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.ПредварительныйПросмотр = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы для прикрепления'");
	
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВладелецХранилища", ВладелецХранилища);		
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеДиалогаВыбораФайлов", ЭтотОбъект, ДополнительныеПараметры);
	
	ДиалогОткрытияФайла.Показать(Оповещение);
	
КонецПроцедуры

// Обработчик события закрытия списка прикрепленных файлов
//
Процедура ЗакрытиеСпискаПрикрепленныхФайлов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Обработка, общая для всех форм объектов
	ДополнительныеПараметры.Форма.Медиафайлы = Результат;
	ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеМедиафайлов(ДополнительныеПараметры.Форма);
	ДополнительныеПараметры.Форма.Модифицированность = Истина;
	
	// Обповещение для выполнения дополнительной обработки события
	Оповестить(ПрикрепленныеФайлыКлиент.ИмяСобытияИзменениеСпискаМультимедиа(), Результат, ДополнительныеПараметры.Форма);
		
КонецПроцедуры

// Обработчик события закрытия списка прикрепленных файлов
//
Процедура ЗакрытиеДиалогаВыбораФайлов(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы = Неопределено) ИЛИ (ВыбранныеФайлы.Количество() = 0) Тогда
		Возврат;
	КонецЕсли;
	
	ВладелецХранилища = ДополнительныеПараметры.ВладелецХранилища;
	Источник = ДополнительныеПараметры.Форма;
	
	Результат = Новый СписокЗначений;

	Для Каждого ИмяФайла Из ВыбранныеФайлы Цикл
		Данные = СтруктураФайлаПоЕгоИмени(ИмяФайла, ВладелецХранилища);
		Если Данные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Добавить(Данные);
	КонецЦикла;
	
	// Обновляем представления файлов
	ПрикрепленныеФайлыВызовСервера.ОбновитьПредставленияФайловВСписке(Результат);
	
	//Оповещаем о выборе
	Оповестить(ПрикрепленныеФайлыКлиент.ИмяСобытияПрикреплениеФайла(), Результат, Источник);
	
КонецПроцедуры

// Удаляет выведенный на форме файл из списка файлов, прикрепленных к объекту
//Обновляются представления фалов на форме и меняется текущий файл
//
//Параметры:
//	Форма	- управляемая форма, из которой вызвана команда удаления
//
//
Процедура УдалитьФайлВДиалоге(Форма) Экспорт

	КоличествоФайлов = Форма.МедиаФайлы.Количество();
	Если КоличествоФайлов > 0 И Форма.ИндексТекущегоФайла <= КоличествоФайлов - 1 Тогда
		
		Форма.МедиаФайлы.Удалить(Форма.МедиаФайлы.Получить(Форма.ИндексТекущегоФайла));
		Если КоличествоФайлов = 1 Тогда
			Форма.ИндексТекущегоФайла = -1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события Нажатие на представление прикрепленного файла
//
//Параметры:
//	Форма- УправляемаяФорма, в которой произошло событие
//	Элемент- Декорация типа картинка, в которой произошло событие
//	СтандартнаяОбработка- Булево - параметр стандартного обработчика
//
Процедура ОбработчикНажатияНаТекущийФайл(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПрикрепленныйФайл = Неопределено;
	КоличествоФайлов = Форма.Медиафайлы.Количество();
	Если КоличествоФайлов > 0 И Форма.ИндексТекущегоФайла >= 0 И Форма.ИндексТекущегоФайла <= КоличествоФайлов - 1 Тогда
		ПрикрепленныйФайл = Форма.Медиафайлы[Форма.ИндексТекущегоФайла].Значение;
	КонецЕсли;
	
	Если ПрикрепленныйФайл = Неопределено Тогда
		
		ДобавитьФайлыВДиалоге(Форма);	
		
	Иначе
		
		ВоспроизвестиФайл(ПрикрепленныйФайл);
		
	КонецЕсли;
	
	ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеТекущегоФайла(Форма);
	
КонецПроцедуры

// Обработчик события Нажатие на декорацию смены текущего файла
//
//Параметры:
//	Форма- УправляемаяФорма, в которой произошло событие
//	Элемент- Декорация типа картинка, в которой произошло событие
//
Процедура ФайлКнопкаНавигацииНажатие(Форма, Элемент) Экспорт
	
	Направление      = ?(Элемент.Имя = "ФайлПредыдущий", -1, 1);
	КоличествоФайлов = Форма.Медиафайлы.Количество();
	
	Если Направление > 0 И КоличествоФайлов - 1 <= Форма.ИндексТекущегоФайла Тогда
		
		ДобавитьФайлыВДиалоге(Форма);	
		
	Иначе
		
		Форма.ИндексТекущегоФайла = Форма.ИндексТекущегоФайла + Направление;
		ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеТекущегоФайла(Форма);
		
	КонецЕсли;
	
	Форма.ТекущийЭлемент = Форма.Элементы.ПредставлениеТекущегоФайла;
	
КонецПроцедуры

// Обрабатывает событие добавления файла в форме, на которой отображается предтавление текущего файла
//
//Параметры:
//	Форма- УправляемаяФорма, в которой произошло событие
//	ОписаниеФайла- Структура, заполненная параметрами файла
//
Процедура ОбработатьОповещениеДобавленияФайла(Форма, ОписаниеФайла) Экспорт
	
	ДобавитьФайлВСписокФормы(Форма, ОписаниеФайла); 
	Форма.ИндексТекущегоФайла = Форма.МедиаФайлы.Количество() - 1;
	ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеТекущегоФайла(Форма);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


// Возвращает фильтр для диалога выбора файлов
//
// Параметры:
//  СпособОткрытия	 - Перечисление.СпособОткрытияПрикрепленногоФайла или Неопределено - Способ открытия выбираемых файлов или неопределено, для полного списка
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ПолучитьФильтрДляДиалогаВыбораФайлов(СпособОткрытия)
	
	Разделитель = "|";
	
	ВсеФайлы = (СпособОткрытия = Неопределено);
	Если Не ВсеФайлы Тогда
		Разделитель = "";
	КонецЕсли;
	
	Фильтр = "";
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакИзображение")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловКартинок();
		Фильтр = Фильтр + НСтр("ru = 'Изображение/фотография'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;	
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакАудиоФайл")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловАудио();
		Фильтр = Фильтр + НСтр("ru = 'Аудио/звук'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;	
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакТекст")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловТекста();
		Фильтр = Фильтр + НСтр("ru = 'Текстовой файл'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакДокументПлатформы")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловПлатформы();
		Фильтр = Фильтр + НСтр("ru = 'Табличный документ 1С:Предприятие'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.КакHTML")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловHTML();
		Фильтр = Фильтр + НСтр("ru = 'Web-страница'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;	
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.СредствамиОС")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловОфиса();
		Фильтр = Фильтр + НСтр("ru = 'Офисные документы'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;
	
	Если ВсеФайлы ИЛИ (СпособОткрытия = ПредопределенноеЗначение("Перечисление.СпособОткрытияПрикрепленногоФайла.СредствамиОС")) Тогда
		Список = ПрикрепленныеФайлыКлиентСервер.СписокРасширенийФайловВидео();
		Фильтр = Фильтр + НСтр("ru = 'Видеозапись'") + "("+Список+")|"+ Список + Разделитель;
	КонецЕсли;
	
	Если ВсеФайлы Тогда
		Фильтр = Фильтр + НСтр("ru = 'Все файлы'") + "(*.*)|*.*";
	КонецЕсли;	
	
	Возврат Фильтр;
	
КонецФункции

// На основе данных файла на диске, готовит и возвращает структуру, описывающую прикрепляемый файл и пригодную 
// для использования как на сервере, так и на клиенте.
//Двоичные данные помещаются во временное хранилище либо с идентификатором формы, либо с произвольным уникатльным идентификатором
//
// Параметры:
//  ИмяФайла			 - Строка - Имя файла на диске
//  ВладелецХранилища	 - УправляемаяФорма или УникальныйИдентификатор - Форма-владелец будущего файла или уникальный идентификатор для сохранения во временном хранилище
// 
// Возвращаемое значение:
//  Структура (см. ПрикрепленныеФайлыКлиентСервер.НоваяСтруктураПрикрепляемогоФайла()) или НЕОПРЕДЕЛЕНО 
//в случае, если устройство не поддерживает мультимедиа
//
Функция СтруктураФайлаПоЕгоИмени(ИмяФайла, ВладелецХранилища = Неопределено)

	Если (ИмяФайла = Неопределено) ИЛИ ПустаяСтрока(ИмяФайла) Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	ТекФайл = Новый Файл(ИмяФайла);
	Если ТекФайл.ЭтоКаталог() ИЛИ (НЕ ТекФайл.Существует()) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ПрикрепленныеФайлыКлиентСервер.НоваяСтруктураПрикрепляемогоФайла();
	
	Результат.СпособОткрытия = ПолучитьСпособОткрытияФайла(ТекФайл);
	Результат.Расширение     = ТекФайл.Расширение;
	Результат.ДатаСоздания   = ТекущаяДата();
	Результат.Размер         = ТекФайл.Размер();
	
	ИД = Неопределено; 
	Если ТипЗнч(ВладелецХранилища) = Тип("УправляемаяФорма") Тогда
		ИД = ВладелецХранилища.УникальныйИдентификатор;
	ИначеЕсли ТипЗнч(ВладелецХранилища) = Тип("УникальныйИдентификатор") Тогда
		ИД = ВладелецХранилища;
	КонецЕсли;
	
	Данные = Новый ДвоичныеДанные(ИмяФайла);
	Результат.НавигационнаяСсылка = ПоместитьВоВременноеХранилище(Данные, ИД);	
	Результат.Наименование        = ТекФайл.ИмяБезРасширения;
	Результат.Иконка              = ПрикрепленныеФайлыКлиентСервер.ИконкаПрикрепленногоФайла(Результат.СпособОткрытия);
	
	Возврат Результат;

КонецФункции

Процедура ОткрытьФайлВПлатформе(ИмяФайла, Расширение) 
	
	Документ = Неопределено;
	
	Если НРег(Расширение) = НРег(".grs") Тогда
		
		Документ = Новый ГрафическаяСхема; 
		
	ИначеЕсли НРег(Расширение) = НРег(".mxl") Тогда
		
		Документ = Новый ТабличныйДокумент;
		
	ИначеЕсли НРег(Расширение) = НРег(".txt") Тогда
		
		Документ = Новый ТекстовыйДокумент;
		
	КонецЕсли;
	
	Если Документ <> Неопределено Тогда
		Документ.Прочитать(ИмяФайла);
		Документ.Показать(ИмяФайла, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры
 

#КонецОбласти


