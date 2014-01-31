class LinearCongruentialGenerator {

	var last:Int;
	var modulus:Int;
	var multiplier:Int;
	var increment:Int;

	public
	function new( modulus, multiplier, increment, seed ) {
		last = seed;
		this.modulus = modulus;
		this.multiplier = multiplier;
		this.increment = increment;
	}

	public
	function next() {
		return last = mod( multiplier*last + increment, modulus );
	}

	public
	function hasNext()
		return true;

	function mod( a:Int, m:Int ) {
		return a >= 0 ? a%m : ( 1 - a )%m;
	}

}
