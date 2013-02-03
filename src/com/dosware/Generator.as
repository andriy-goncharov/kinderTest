package com.dosware
{
	import mx.collections.ArrayCollection;

	public class Generator
	{
		
		private const MAXNUM:int = 90;
		private const MINNUM:int = 9;
		private var FirstNum:int;
		private var SeconsNum:int;
		private var _task:String;
		private var znak:Boolean; // + = true - = false
		private var _thisAnswerIsCorect:Boolean;
		public var Statistic:ArrayCollection;
		public var Counter:int;
		public var colCorrAnsw:int;
		
		
		public function Generator()
		{
			Statistic = new ArrayCollection();
			getTask();
			
		}
		/// получение одного примера ////

		public function get validity():Boolean
		{
			return _thisAnswerIsCorect;
		}

		private function getTask():String
		{
			var zn:String = (getZnak())?"+":"-";
			FirstNum  = Math.floor(Math.random()* MAXNUM)+ MINNUM;
			SeconsNum = Math.floor(Math.random()* MAXNUM)+ MINNUM;
			_task = FirstNum.toString()+" "+zn+" "+SeconsNum.toString();
			return _task;
		}
		/// получение знака примера /////
		private function getZnak():Boolean
		{
			znak = Math.random() < .5;
			return znak;
		}
		////// получение правильного ответа /////
		private function correctAnsver():String
		{
			if (znak) 
			{
				return String(FirstNum+SeconsNum);
			}else{
				return String(FirstNum-SeconsNum);	
			}
			
		}
		
		//////// создание заданий и заполнение масссива ответов /////////
		public function genAndStatistic(userAnsw:String = ""):void
		{
			//////// в ячейку кладем задание+ответ пользователя+правильный ответ ///////
//			Statistic[Counter] = _task+ " "+userAnsw+" "+correctAnsver()+'\n';
			Statistic.addItem({exemple:_task,answer:userAnsw,correct:correctAnsver()});
			if (userAnsw == correctAnsver()) 
			{
				colCorrAnsw++;
				_thisAnswerIsCorect = true;
				
			}else{	
				_thisAnswerIsCorect = false;	
			}
			getTask();
			Counter++;
			
		}
		
		public function get task():String
		{
			return _task;
		}
		public function Reset():void
		{
			Statistic.removeAll();
			Counter = 0;
			colCorrAnsw = 0;
		}
		
		

	}
}