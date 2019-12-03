class Pirata {
	var property energiaInicial
	method poderMando()
	method esFuerte() = self.poderMando() > 100
	method tomarRon() {
		energiaInicial -= 50
	}
	//method serHerido() Porque las subclases la implementan de forma distinta
}

class Guerrero inherits Pirata {
	var poderPelea
	var vitalidad
	override method poderMando() = poderPelea * vitalidad
	method serHerido() {
		poderPelea /= 2
	}
}

class Navegador inherits Pirata{
	var inteligencia
	override method poderMando() = inteligencia ** 2
	method serHerido() {
		inteligencia /= 2
	}
}

class Cocinero inherits Pirata {
	var ingredientes = [] 
	var moral
	method serHerido() {
		moral /= 2
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
	var poderPelea = 200
	var inteligencia = 300
	var ingredientes = ["botellaRon"]
	method serHerido(){
		poderPelea /= 2
		inteligencia /= 2
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
	
	method desolar() {
		resistencia = 0
		poderFuego = 0
		municiones = 0
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
		tripulacion.removeAllSuchThat({tripulante => tripulante.energiaInicial()<20})
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
	
	method tripulacionHerida() {
		tripulacion.forEach({tripulante => tripulante.serHerido()})
	}
	
	method engrentarA(enemigo) {
		if(self.leGanaEnFuerzaA(enemigo))
		{
			self.agregarTripulantesEnemigos(enemigo)
			enemigo.perderTripulacionTotalmente()
			enemigo.tripulacionHerida()
			enemigo.desolar()
		}		
	}	
	
	method dispararCanionA(canionazos, enemigo){
		if(municiones < 0)
			self.error("No hay munciones para disparar")
		self.disminuirMunicion(canionazos)
		enemigo.disminuirResistencia(50*canionazos)
	}
	
	method aplicarBonus(){
		bando.aplicarBonus(self)
	}
}

object armadaInglesa {
	method aplicarBonus(barco){
		barco.aumentarMunicion(0.3)
	}
}

object unionPirata {
	method aplicarBonus(barco){
		barco.aumentarPoderFuego(60)
	}		
}

object armadaHolandes {
	method aplicarBonus(barco){
		barco.duplicarTripulacion()
	}
}
