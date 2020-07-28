﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	ИзвлекатьТекстыФайловНаСервере = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
	
	// Настройки видимости при запуске.
	Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Видимость = Пользователи.ЭтоПолноправныйПользователь() И Не ОбщегоНазначения.РазделениеВключено();
	
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь();
	Если ЭтоАдминистраторСистемы И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			СписокВыбора = Элементы.ИзвлекатьТекстыФайловНаСервереWindows.СписокВыбора;
			СписокВыбора[0].Представление = НСтр("ru = 'Все рабочие станции работают под управлением ОС Windows'");
			
			СписокВыбора = Элементы.ИзвлекатьТекстыФайловНаСервереLinux.СписокВыбора;
			СписокВыбора[0].Представление = НСтр("ru = 'Одна или несколько рабочих станций работают под управлением ОС Linux'");
		КонецЕсли;
	Иначе
		Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Видимость = Ложь;
	КонецЕсли;
	Если Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Видимость Тогда
		СведенияОРегламентныхЗаданиях = Новый Структура;
		ЗаполнитьСведенияОРегламентномЗадании("ИзвлечениеТекста");
	Иначе
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Управление полнотекстовым поиском'");
		Элементы.ОписаниеРаздела.Заголовок =
			НСтр("ru = 'Включение и отключение полнотекстового поиска, обновление индекса полнотекстового поиска.'");
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(
		ЭтотОбъект, "ГруппаАвтоматическоеИзвлечениеТекстов");
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИзвлекатьТекстыФайловНаСервереПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерИндексируемыхДанныхПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничитьМаксимальныйРазмерИндексируемыхДанныхПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОбновитьИндексСервер();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет очистка полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОчиститьИндексСервер();
	
	Состояние(НСтр("ru = 'Очистка полнотекстового индекса завершена.'"));
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет проверка полнотекстового индекса...
		|Пожалуйста, подождите.'"));
		
	Попытка
		ПроверитьИндексСервер();
	Исключение
		ТекстСообщенияОбОшибке = 
			НСтр("ru = 'В настоящее время проверка индекса невозможна, так как выполняется его очистка или обновление.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
	КонецПопытки;
	
	Состояние(НСтр("ru = 'Проверка полнотекстового индекса завершена.'"));
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьРегламентноеЗадание(Команда)
	РегламентныеЗаданияГиперссылкаНажатие("ИзвлечениеТекста");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если Результат.Свойство("НеУдалосьУстановитьРежимПолнотекстовогоПоиска") Тогда
		// Выдача предупреждающего сообщения.
		ТекстВопроса = НСтр("ru = 'Для изменения режима полнотекстового поиска требуется завершение сеансов всех пользователей, кроме текущего.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("АктивныеПользователи", НСтр("ru = 'Активные пользователи'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Обработчик = Новый ОписаниеОповещения("ПриИзмененииРеквизитаПослеОтветаНаВопрос", ЭтотОбъект);
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, , "АктивныеПользователи");
		Возврат;
	КонецЕсли;
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если Результат.КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат.КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ИмяПредопределенного)
	Сведения = СведенияОРегламентныхЗаданиях[ИмяПредопределенного];
	Если Сведения.Идентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Контекст = Новый Структура;
	Контекст.Вставить("ИмяПредопределенного", ИмяПредопределенного);
	Контекст.Вставить("ФлажокИзменен", Ложь);
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, Контекст);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Сведения.Расписание);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, Контекст) Экспорт
	Если Расписание = Неопределено Тогда
		Если Контекст.ФлажокИзменен Тогда
			ЭтотОбъект[Контекст.ИмяФлажка] = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если Контекст.ФлажокИзменен Тогда
		ЭтотОбъект[Контекст.ИмяФлажка] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(Контекст.ИмяПредопределенного, Изменения, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитаПослеОтветаНаВопрос(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ = "АктивныеПользователи" Тогда
		СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	УстановитьДоступность("Команда.ОбновитьИндекс");
КонецПроцедуры

&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
	УстановитьДоступность("Команда.ОчиститьИндекс");
КонецПроцедуры

&НаСервере
Процедура ПроверитьИндексСервер()
	ИндексСодержитКорректныеДанные = ПолнотекстовыйПоиск.ПроверитьИндекс();
	УстановитьДоступность("Команда.ПроверитьИндекс", Истина);
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	Результат = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	Если Результат.Свойство("НеУдалосьУстановитьРежимПолнотекстовогоПоиска") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(ИмяПредопределенного, Изменения, УстановитьВидимостьДоступность)
	Сведения = СведенияОРегламентныхЗаданиях[ИмяПредопределенного];
	Если Сведения.Идентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	РегламентныеЗаданияСервер.ИзменитьЗадание(Сведения.Идентификатор, Изменения);
	ЗаполнитьЗначенияСвойств(Сведения, Изменения);
	СведенияОРегламентныхЗаданиях.Вставить(ИмяПредопределенного, Сведения);
	Если УстановитьВидимостьДоступность Тогда
		УстановитьДоступность("РегламентноеЗадание." + ИмяПредопределенного);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	Результат = Новый Структура("КонстантаИмя", "");
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ИзвлекатьТекстыФайловНаСервере" Тогда
			КонстантаИмя = "ИзвлекатьТекстыФайловНаСервере";
			НаборКонстант.ИзвлекатьТекстыФайловНаСервере = ИзвлекатьТекстыФайловНаСервере;
			Изменения = Новый Структура("Использование", НаборКонстант.ИзвлекатьТекстыФайловНаСервере);
			РегламентныеЗаданияСохранить("ИзвлечениеТекста", Изменения, Ложь);
		ИначеЕсли РеквизитПутьКДанным = "МаксимальныйРазмерИндексируемыхДанных"
			Или РеквизитПутьКДанным = "ОграничитьМаксимальныйРазмерИндексируемыхДанных" Тогда
			Попытка
				Если ОграничитьМаксимальныйРазмерИндексируемыхДанных Тогда
					// При первом включении ограничения устанавливается значение по умолчанию платформы - 1 Мб.
					Если МаксимальныйРазмерИндексируемыхДанных = 0 Тогда
						МаксимальныйРазмерИндексируемыхДанных = 1;
					КонецЕсли;
					Если ПолнотекстовыйПоиск.ПолучитьМаксимальныйРазмерИндексируемыхДанных() <> МаксимальныйРазмерИндексируемыхДанных * 1048576 Тогда
						ПолнотекстовыйПоиск.УстановитьМаксимальныйРазмерИндексируемыхДанных(МаксимальныйРазмерИндексируемыхДанных * 1048576);
					КонецЕсли;
				Иначе
					ПолнотекстовыйПоиск.УстановитьМаксимальныйРазмерИндексируемыхДанных(0);
				КонецЕсли;
			Исключение
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Полнотекстовый поиск'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Результат.Вставить("НеУдалосьУстановитьРежимПолнотекстовогоПоиска", Истина);
				Возврат Результат;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Результат.КонстантаИмя = КонстантаИмя;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "", ИндексПроверен = Ложь)
	
	Если РеквизитПутьКДанным = "" Или РеквизитПутьКДанным = "ИспользоватьПолнотекстовыйПоиск" Тогда
		МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
		Если НаборКонстант.ИспользоватьПолнотекстовыйПоиск <> МодульПолнотекстовыйПоискСервер.ОперацииРазрешены() Тогда
			ИспользоватьПолнотекстовыйПоиск = 2;
		Иначе
			ИспользоватьПолнотекстовыйПоиск = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		КонецЕсли;
		Элементы.ГруппаУправлениеПолнотекстовымПоиском.Доступность = (ИспользоватьПолнотекстовыйПоиск = 1);
		Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Доступность = (ИспользоватьПолнотекстовыйПоиск = 1);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = ""
		Или РеквизитПутьКДанным = "ОграничитьМаксимальныйРазмерИндексируемыхДанных"
		Или РеквизитПутьКДанным = "МаксимальныйРазмерИндексируемыхДанных"
		Или РеквизитПутьКДанным = "ИспользоватьПолнотекстовыйПоиск"
		Или РеквизитПутьКДанным = "Команда.ОбновитьИндекс"
		Или РеквизитПутьКДанным = "Команда.ОчиститьИндекс"
		Или РеквизитПутьКДанным = "Команда.ПроверитьИндекс" Тогда
		
		Если ИспользоватьПолнотекстовыйПоиск = 1 Тогда
			ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
			МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
			ИндексАктуален = МодульПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
			ФлагДоступность = НЕ ИндексАктуален;
			Если ИндексПроверен И Не ИндексСодержитКорректныеДанные Тогда
				СтатусИндекса = НСтр("ru = 'Требуется очистка и обновление'");
			ИначеЕсли ИндексАктуален Тогда
				СтатусИндекса = НСтр("ru = 'Обновление не требуется'");
			Иначе
				СтатусИндекса = НСтр("ru = 'Требуется обновление'");
			КонецЕсли;
		Иначе
			ДатаАктуальностиИндекса = '00010101';
			ИндексАктуален = Ложь;
			ФлагДоступность = Ложь;
			СтатусИндекса = НСтр("ru = 'Полнотекстовый поиск отключен'");
		КонецЕсли;
		МаксимальныйРазмерИндексируемыхДанных = ПолнотекстовыйПоиск.ПолучитьМаксимальныйРазмерИндексируемыхДанных() / 1048576;
		ОграничитьМаксимальныйРазмерИндексируемыхДанных = МаксимальныйРазмерИндексируемыхДанных <> 0;
		
		Элементы.МаксимальныйРазмерИндексируемыхДанных.Доступность = ОграничитьМаксимальныйРазмерИндексируемыхДанных;
		Элементы.ДекорацияМб.Доступность = ОграничитьМаксимальныйРазмерИндексируемыхДанных;
		
		Если (ИндексПроверен И Не ИндексСодержитКорректныеДанные)
			Или Не ИндексАктуален Тогда
			Элементы.СтатусИндекса.Шрифт = Новый Шрифт(, , Истина);
		Иначе
			Элементы.СтатусИндекса.Шрифт = Новый Шрифт;
		КонецЕсли;
		
		Элементы.ОбновитьИндекс.Доступность = ФлагДоступность;
		
	КонецЕсли;
	
	Если Элементы.ГруппаАвтоматическоеИзвлечениеТекстов.Видимость
		И (РеквизитПутьКДанным = ""
		Или РеквизитПутьКДанным = "ИзвлекатьТекстыФайловНаСервере"
		Или РеквизитПутьКДанным = "РегламентноеЗадание.ИзвлечениеТекста") Тогда
		Элементы.РедактироватьРегламентноеЗадание.Доступность = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		Элементы.ЗапуститьИзвлечениеТекстов.Доступность       = Не НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		Если НаборКонстант.ИзвлекатьТекстыФайловНаСервере Тогда
			Сведения = СведенияОРегламентныхЗаданиях["ИзвлечениеТекста"];
			РасписаниеПредставление = Строка(Сведения.Расписание);
			РасписаниеПредставление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			РасписаниеПредставление = НСтр("ru = 'Автоматическое извлечение текстов не выполняется.'");
		КонецЕсли;
		Элементы.РедактироватьРегламентноеЗадание.РасширеннаяПодсказка.Заголовок = РасписаниеПредставление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОРегламентномЗадании(ИмяПредопределенного)
	Сведения = Новый Структура("Идентификатор, Использование, Расписание");
	СведенияОРегламентныхЗаданиях.Вставить(ИмяПредопределенного, Сведения);
	Задание = РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного);
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Сведения.Идентификатор = Задание.УникальныйИдентификатор;
	Сведения.Использование = Задание.Использование;
	Сведения.Расписание    = Задание.Расписание;
КонецПроцедуры

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	Фильтр = Новый Структура("Метаданные", ИмяПредопределенного);
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Фильтр);
	Возврат ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
КонецФункции

#КонецОбласти
