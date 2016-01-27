package game.ui.inventory.filter
{
	

	public class IntFilter extends Filter
	{
		public function IntFilter(_type:int, _value:*, _operator:int)
		{
			super(_type, _value, _operator);
		}
		
		override public function evaluate(value:*):Boolean
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
			}
			return false;
		}
	}
}