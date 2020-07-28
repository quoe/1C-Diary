﻿#Область ПрограммныйИнтерфейс

// Переопределяет стандартное поведение подсистемы Пользователи.
//
// Параметры:
//  Настройки - Структура - со свойствами:
//   * ОбщиеНастройкиВхода - Булево - определяет будут ли в панели администрирования
//          "Настройки прав и пользователей" доступны настройки входа и доступность
//          настроек ограничения срока действия в формах пользователя и внешнего пользователя.
//          По умолчанию, Истина, а для базовых версий конфигурации - всегда Ложь.
//
//   * РедактированиеРолей - Булево - определяет доступность интерфейса изменения ролей 
//          в карточках пользователя, внешнего пользователя и группы внешних пользователей
//          (в том числе для администратора). По умолчанию, Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	// ДЕНЬГИ
	Настройки.РедактированиеРолей = Ложь;
	// Конец ДЕНЬГИ
	
КонецПроцедуры

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// Большинство ролей конфигурации не требуется здесь указывать, т.к. они предназначены для любых пользователей, 
// кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнегоПользователя.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ДобавлениеИзменениеЛичныхВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// ДЕНЬГИ
	//НазначениеРолей.ТолькоДляАдминистраторовСистемы.Добавить("ПолныеПрава");
	НазначениеРолей.ТолькоДляАдминистраторовСистемы.Добавить("АдминистраторСистемы");
	
	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить("ПолныеПрава");
	//НазначениеРолей.ТолькоДляПользователейСистемы.Добавить("АдминистраторСистемы");
	// Конец ДЕНЬГИ 
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриОпределенииНазначенияРолей(НазначениеРолей);
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей, когда оно должно отличаться от поведения по умолчанию.
//
// Например, требуется скрывать/показывать или разрешать изменять/блокировать
// некоторые свойства в случаях, которые определены прикладной логикой.
//
// Параметры:
//  ПользовательИлиГруппа - СправочникСсылка.Пользователи,
//                          СправочникСсылка.ВнешниеПользователи,
//                          СправочникСсылка.ГруппыВнешнихПользователей - ссылка на пользователя,
//                          внешнего пользователя или группу внешних пользователей при создании формы.
//
//  ДействияВФорме - Структура - со свойствами:
//         * Роли                   - Строка - "", "Просмотр", "Редактирование".
//                                             Например, когда роли редактируются в другой форме можно скрыть
//                                             их в этой форме или только блокировать редактирование.
//         * КонтактнаяИнформация   - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться скрыть контактную информацию
//                                             от пользователя при отсутствии прикладных прав на просмотр КИ.
//         * СвойстваПользователяИБ - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться показать свойства пользователя ИБ
//                                             для пользователя, который имеет прикладные права на эти сведения.
//         * СвойстваЭлемента       - Строка - "", "Просмотр", "Редактирование".
//                                             Например, Наименование, является полным именем пользователя ИБ,
//                                             может потребоваться разрешить редактировать наименование
//                                             для пользователя, который имеет прикладные права на кадровые операции.
//
Процедура ИзменитьДействияВФорме(Знач ПользовательИлиГруппа, Знач ДействияВФорме) Экспорт
	
	// ДЕНЬГИ
	Если ТипЗнч(ПользовательИлиГруппа) = Тип("СправочникСсылка.Пользователи") Тогда
		ДействияВФорме.Роли                   = ""; // Не показывать
		ДействияВФорме.КонтактнаяИнформация   = ""; // Не показывать
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
	КонецЕсли;
	// Конец ДЕНЬГИ
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры Пользователи.ЗаписатьПользователяИБ, если пользователь был действительно изменен.
// Если поле Имя в структуре СтарыеСвойства не заполнено, значит создается новый пользователь ИБ.
//
// Параметры:
//  СтарыеСвойства - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//  НовыеСвойства  - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
	// ДЕНЬГИ
	Если НовыеСвойства.Роли = Неопределено Тогда
		НовыеСвойства.Роли = Новый Массив;
	КонецЕсли;
	
	Если НовыеСвойства.Роли.Количество() = 0 Тогда
		
		// В базовой версии обязательно наличие ролей "Администрирование" и "ПолныеПрава"
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(НовыеСвойства.УникальныйИдентификатор);
		Если ПользовательИБ <> Неопределено Тогда
			ПользовательИБ.Роли.Добавить(Метаданные.Роли.АдминистраторСистемы);
			ПользовательИБ.Роли.Добавить(Метаданные.Роли.ПолныеПрава);
			ПользовательИБ.Записать();
		КонецЕсли;
		
		НовыеСвойства.Роли.Добавить(Метаданные.Роли.АдминистраторСистемы);
		НовыеСвойства.Роли.Добавить(Метаданные.Роли.ПолныеПрава);
		
	КонецЕсли;
	// Конец ДЕНЬГИ 
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры УдалитьПользователяИБ, если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
// Например, можно установить начальные настройки расположения разделов командного интерфейса.
//
// Параметры:
//  НачальныеНастройки - Структура - настройки по умолчанию:
//   * НастройкиКлиента    - НастройкиКлиентскогоПриложения           - настройки клиентского приложения.
//   * НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса            - настройки командного интерфейса (панели
//                                                                      разделов, панели навигации, панели действий).
//   * НастройкиТакси      - НастройкиИнтерфейсаКлиентскогоПриложения - настройки интерфейса клиентского приложения
//                                                                      (состав и размещение панелей).
//
//   * ЭтоВнешнийПользователь - Булево - если Истина, то это внешний пользователь.
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет добавить произвольную настройку на закладке "Прочее" в интерфейсе
// обработки НастройкиПользователей, чтобы ее можно было удалять и копировать другим пользователям.
// Для возможности управления настройкой нужно написать код ее по копированию (см. ПриСохраненииПрочихНастроек)
// и удалению (см. ПриУдаленииПрочихНастроек), который будет вызываться при интерактивных действиях с настройкой.
//
// Например, признак того, нужно ли показывать предупреждение при завершении работы программы.
//
// Параметры:
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка  - СправочникСсылка.Пользователи - пользователь,
//                               у которого нужно получить настройки.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             у которого нужно получить настройки.
//  Настройки - Структура - прочие пользовательские настройки.
//       * Ключ     - Строка - строковый идентификатор настройки, используемый в дальнейшем
//                             для копирования и очистки этой настройки.
//       * Значение - Структура - информация о настройке.
//              ** НазваниеНастройки  - Строка - название, которое будет отображаться в дереве настроек.
//              ** КартинкаНастройки  - Картинка - картинка, которая будет отображаться в дереве настроек.
//              ** СписокНастроек     - СписокЗначений - список полученных настроек.
//
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Сохраняет произвольную настройку переданному пользователю.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор копируемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений копируемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно скопировать настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно скопировать настройку.
//
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Очищает произвольную настройку у переданного пользователя.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор очищаемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений очищаемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно очистить настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно очистить настройку.
//
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
