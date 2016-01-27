package game.ui.inventory.filter
{
	public class BooleanFilter extends Filter
	{
		public function BooleanFilter(_type:int, _value:int, _operator:int)
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
			}
			return false;
		}
	}
}