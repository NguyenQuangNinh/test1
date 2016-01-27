package game.ui.inventory.filter
{
	import game.utility.ElementUtil;

	public class Filter
	{
		public var type:int;
		public var value:*;
		public var operator:int;
		
		public function Filter(_type:int, _value:*, _operator:int){
			this.type = _type;
			this.value = _value;
			this.operator = _operator;
		}
		
		public function evaluate(value:*):Boolean
		{
			switch(operator)
			{
				case Operator.EQUALS:
					return value == this.value;
				case Operator.NOT_EQUALS:
					return value != this.value;
				case Operator.GREATER:
					return value > this.value;
				case Operator.GREATER_OR_EQUALS:
					return value >= this.value;
				case Operator.LESS:
					return value < this.value;
				case Operator.LESS_OR_EQUALS:
					return value <= this.value;
				case Operator.OVERCOMING:
					return (value !=  ElementUtil.generatingElement(this.value));
				case Operator.GENERATING:
					return (value != ElementUtil.overComingElement(this.value));
			}
			return false;
		}
	}
}