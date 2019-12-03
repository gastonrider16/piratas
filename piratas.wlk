class Pirata {
	var energiaInicial
	var property poderPelea = 0
	var vitalidad = 0
	var property inteligencia = 0
	var property moral = 0
	method poderMando()
	method esFuerte() = self.poderMando() > 100
	method tomarRon() {
		energiaInicial -= 50
	}
	method disminuirAtributos()
	method desolar()
	method energiaInicialMenorA20() = energiaInicial < 20
}

class Guerrero inherits Pirata {
	//var energiaInicial
	//var poderPelea
	//var vitalidad
	override method poderMando() = poderPelea * vitalidad
	override method disminuirAtributos() {
		poderPelea /= 2
	}
	override method desolar() {
		self.poderPelea(0)
	}
}

class Navegador inherits Pirata{
	//var energiaInicial
	//var inteligencia
	override method poderMando() = inteligencia ** 2
	override method disminuirAtributos() {
		inteligencia /= 2
	}
	override method desolar() {
		self.inteligencia(0)
	}
}

class Cocinero inherits Pirata {
	//var energiaInicial
	var ingredientes = [] 
	//var moral
	override method disminuirAtributos() {
		moral /= 2
	}
	override method desolar() {
		self.moral(0)
	}
	method agregarIngrediente(ingrediente) {
		ingredientes.add(ingrediente)
	}
	override method poderMando() = moral * ingredientes.size()
	override method tomarRon() {
		super()
		self.perderIngrediente()
	}
	method perderIngrediente() {
		var ingredientePerdido = ingredientes.anyOne()
		ingredientes.remove(ingredientePerdido)
		jackSparrow.agregarIngrediente(ingredientePerdido)
	}
}

object jackSparrow inherits Pirata {
	//energiaInicial = 500
	//poderPelea = 200
	//inteligencia = 300
	var ingredientes = ["botellaRon"]
	override method disminuirAtributos(){
		poderPelea /= 2
		inteligencia /= 2
	}
	override method desolar(){
		poderPelea = 0
		inteligencia = 0
	}
	method agregarIngrediente(ingrediente){
		ingredientes.add(ingrediente)
	}
	override method poderMando() = energiaInicial * poderPelea * inteligencia
	method tomarRon(pirata) {
		energiaInicial += 100
		pirata.tomarRon()
	}
}

class Barco {
	var resistencia
	var poderFuego
	var municiones
	var property tripulacion = []
	var property bando
	method agregarTripulacion(tripulante){
		tripulacion.add(tripulante)
	}
	
	method disminuirResistencia(disminucion){
		resistencia = 0.max(resistencia-disminucion)
	}
	
	method disminuirMunicion(disminucion){
		municiones = 0.max(resistencia-disminucion)
	}
	
	method aumentarMunicion(producto){
		municiones += municiones*producto
	}
	
	//method poderMandoTripulantes() = tripulacion.map({tripulante => tripulante.poderMando()})
	//method fuerza() = self.poderMandoTripulantes().sum()
	
	method fuerza() = tripulacion.sum({tripulante => tripulante.poderMando()})
	
	method leGanaEnFuerzaA(enemigo) = self.fuerza() > enemigo.fuerza()
	
	method tripulantesFuertes() = tripulacion.filter({tripulante => tripulante.esFuerte()})
	
	method esCapitan() = tripulacion.max({tripulante => tripulante.poderMando()})
	
	method agregarTripulantesEnemigos(enemigo){
		tripulacion.addAll(enemigo.tripulantesFuertes())
	}
	
	method perderTripulacionTotalmente() {
		tripulacion.clear()
	}
	
	method perderTripulacion(){
		tripulacion.removeAllSuchThat({tripulante => tripulante.energiaInicialMenorA20()})
	}
	
	method disminuirPoderPelea() {
		tripulacion.forEach({tripulante => tripulante.disminuirAtributos()})
	}
	
	method aumentarPoderFuego(aumento) {
		tripulacion += aumento
	}
	
	method duplicarTripulacion(){
		tripulacion.addAll(tripulacion)
	}
	
	method desolar() {
		tripulacion.forEach({tripulante => tripulante.desolar()})
	}
	
	method engrentarA(enemigo) {
		if(self.leGanaEnFuerzaA(enemigo))
		{
			self.agregarTripulantesEnemigos(enemigo)
			enemigo.perderTripulacionTotalmente()
			self.disminuirPoderPelea()	
			self.desolar()
		}		
	}	
	
	method dispararCanionA(canionazos, enemigo){
		if(municiones < 0)
			self.error("No hay munciones para disparar")
		self.disminuirMunicion(canionazos)
		enemigo.disminuirResistencia(50*canionazos)
	}
	
	method recibirBonus(){
		if(bando == "armadaInglesa")
			self.aumentarMunicion(0.3)
		if(bando == "unionPirata")
			self.aumentarPoderFuego(60)
		if(bando == "armadaHolandes")
			self.duplicarTripulacion()
	}
}
