﻿

Функция КоличествоСлов(Строка) Экспорт
	
	Строка = СокрЛП(Строка);
	Пока Найти (Строка, "  ") Цикл
		Строка = СтрЗаменить (Строка, "  "," ");
	КонецЦикла;
	
	КоличествоСловВСтроке = СтрЧислоВхождений(Строка," ") + 1;
	
	Возврат КоличествоСловВСтроке;
	
КонецФункции // КоличествоСлов()

Функция ЗаменитьСимволыПоШаблону(Строка, ШаблонЗамены, ЗаменитьНа = "") Экспорт
	
	Если ПустаяСтрока(Строка) ИЛИ ПустаяСтрока(ШаблонЗамены) Тогда
		Возврат Строка; 
	КонецЕсли;
	
	RegExp 				= Новый COMОбъект("VBScript.RegExp"); //Для 1C v 7.x: CreateObject("VBScript.RegExp") 
	RegExp.IgnoreCase 	= Истина; //Игнорировать регистр 
	RegExp.Global 		= Истина; //Поиск всех вхождений шаблона 
	RegExp.MultiLine 	= Истина; //Многострочный режим 
	RegExp.Pattern 		= ШаблонЗамены; 
	
	Возврат RegExp.Replace(Строка, ЗаменитьНа);
	
КонецФункции // ЗаменитьСимволыПоШаблону()

Функция ОчиститьСтрокуОтСимволов(Строка, СимволыДляОчищения)Экспорт
	
	Возврат ЗаменитьСимволыПоШаблону(Строка, "[" + СимволыДляОчищения + "]") ;
	
КонецФункции // ОчиститьСтркуОтСимвола()

Функция ОчиститьСтрокуПоШаблону(Строка, Шаблон)
	
	Возврат ЗаменитьСимволыПоШаблону(Строка, Шаблон) 
	
КонецФункции // ОчиститьСтрокуПоШаблону()

Функция ОтобратьТолькоЧисла(Строка)
	
	Возврат ЗаменитьСимволыПоШаблону(Строка, "[^0-9]");
	
КонецФункции // ОтобратьТолькоЧисла()