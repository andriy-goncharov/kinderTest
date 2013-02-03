
import com.dosware.Generator;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.sampler.NewObjectSample;
import flash.utils.Timer;

import flashx.textLayout.factory.TruncationOptions;

import mx.controls.Alert;
import mx.core.IFactory;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.StateChangeEvent;
import mx.states.OverrideBase;

public static const MODE_TIME:int = 0;
public static const MODE_TIME_AND_QUEST:int = 1;
public static const MODE_QUEST:int = 2;
public static const MODE_COLOR:Boolean = false;
private var AllTimeTesting:int = 10;
private var AllColQuest:int = 10;
private var timer:Timer; 
private var generator:Generator;
//private var counterQuest:int


///////////////// обработка событий //////////
public function setting_clickHandler(event:MouseEvent):void
{
	testButton.enabled = false;
	settingBox.visible = true;
	formTesting.enabled = false;
	
	
	
}
private function test_clickHandler(event:MouseEvent):void
{
	settingButton.enabled = false;
	settingBox.visible = false;
	formTesting.visible = true;	
	testButton.enabled = false;
	startTest(modeTesting.selectedIndex);
	generator.Reset();
	LabelQuest.text = generator.task +" =";
	formTesting.enabled = true;
	answerText.setFocus();
//	trace("время ",AllTimeTesting," вопросы", AllColQuest); 
	
}
protected function okSettimgs_clickHandler(event:MouseEvent):void
{
	
	getSetting();
	if ((AllTimeTesting  < 5) && (AllColQuest == 0)) 
	{
		Alert.show("неправильные данные");		
	}else if((modeTesting.selectedIndex == MODE_TIME_AND_QUEST ) && ((AllTimeTesting < 5) || (AllColQuest == 0)))
	{
		Alert.show("неправильные данные");
	}else{
		settingButton.enabled = true;
		testButton.enabled = true;
		settingBox.visible = false;

	}
	
	/////////////////////// получение настроек ////////////
}

private function ProcessTimer(e:TimerEvent):void
{
	WorkResponse();
}
private function stopTheTimer(e:TimerEvent):void
{
	stopTest();
}
protected function okReport_clickHandler(event:MouseEvent):void
{
	initialState();	
}

/////// обработка ответа на вопрос ////////////////////////
protected function answerButton_clickHandler(event:MouseEvent):void
{
	WorkResponse();
	if (modeTesting.selectedIndex == MODE_TIME_AND_QUEST) 
	{
		timer.reset();
		timer.start();
	}
	
}

protected function answerText_enterHandler(event:FlexEvent):void
{
	WorkResponse();
	if (modeTesting.selectedIndex == MODE_TIME_AND_QUEST) 
	{
		timer.reset();
		timer.start();
	}
}
protected function modeTesting_changeHandler(event:ListEvent):void
{
	if (modeTesting.selectedIndex == MODE_TIME) 
	{
		minTesting.enabled = true;
		secTesting.enabled = true;
		colQuestTesting.enabled = false;
		colQuestTesting.value = 0;
	}
	else if (modeTesting.selectedIndex == MODE_TIME_AND_QUEST) 
	{
		minTesting.enabled = true;
		secTesting.enabled = true;
		colQuestTesting.enabled = true;
	}
	else if (modeTesting.selectedIndex == MODE_QUEST)
	{
		minTesting.enabled = false;
		secTesting.enabled = false;
		colQuestTesting.enabled = true;
		minTesting.value = 0;
		secTesting.value = 0;
	}
	
}

////////////////// обработка //////////////// 


private function getSetting():void
{
	AllTimeTesting = int(minTesting.value * 60 + secTesting.value);
	AllColQuest = int(colQuestTesting.value);
}

private function startTest(mode:int):void
{ 
	if (mode == MODE_TIME) 
	{
		timer = new Timer(AllTimeTesting*1000,1);
		generator = new Generator();
		timer.start();
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,stopTheTimer);
	}else if(mode == MODE_TIME_AND_QUEST)
	{
		timer = new Timer(AllTimeTesting*1000,AllColQuest);
		generator = new Generator();
		timer.start();
		timer.addEventListener(TimerEvent.TIMER,ProcessTimer);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,stopTheTimer);
	}else if(mode == MODE_QUEST)
	{
		generator = new Generator();
		
	}	
	
}

private function stopTest():void
{
	Alert.yesLabel = "Да";
	Alert.noLabel = "Нет";
	Alert.show("посмотреть статистику","тест",3,null,showStatistic);
	LabelQuest.text = "";
	if (timer) 
	{
		timer.stop();
		timer.removeEventListener(TimerEvent.TIMER,ProcessTimer);
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE,stopTheTimer);
	}
	
}

private function showStatistic(e:CloseEvent):void
{
	if (e.detail == Alert.YES) 
	{
//		report.text = String(generator.Statistic);
		dataGrid.dataProvider = generator.Statistic;
		formreport.visible = true;
		colQuest.text = String(generator.Counter);
		colCorAnsw.text = String(generator.colCorrAnsw);
		///////////////// показать оттчет ///////////////
	}else{
		generator.Reset();
		initialState();
	}	
	
}

private function WorkResponse():void
{
	if (checkAnsv.selected) 
	{
		paintRect(generator.validity);
	}	
	generator.genAndStatistic(answerText.text);
	answerText.text = "";
	LabelQuest.text = generator.task + " =";
	if (((modeTesting.selectedIndex == MODE_QUEST) || (modeTesting.selectedIndex == MODE_TIME_AND_QUEST))
		&& (generator.Counter == AllColQuest)) 
	{
		stopTest();
		initialState();	
	}
}

private function initialState():void
{
	formreport.visible = false;
	settingButton.enabled = true;
	testButton.enabled = true;
	answerText.text = "";
	formTesting.enabled = false; 
	answerButton.enabled = true;
	colorAnsver.graphics.clear();
}

private function paintRect(color:Boolean):void
{
	if (color) 
	{
		colorAnsver.graphics.clear();
		colorAnsver.graphics.beginFill(0x24b911);
		colorAnsver.graphics.drawRect(0,0,colorAnsver.height,colorAnsver.width);
	}else{
		colorAnsver.graphics.clear();
		colorAnsver.graphics.beginFill(0xff0000);
		colorAnsver.graphics.drawRect(0,0,colorAnsver.height,colorAnsver.width);
	}
		
}

