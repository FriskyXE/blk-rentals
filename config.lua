Config = {}

Config.Boats = {
    {label = 'Dinghy', model = 'dinghy', price = 100, image = 'https://media.discordapp.net/attachments/673503448427266059/1261988116949110834/dinghy.png?ex=6694f585&is=6693a405&hm=7470fa5f64ad82ea91679a28666c6c711e91261c7bcf8a27e161c7ac4d6da140&=&format=webp&quality=lossless&width=550&height=310'},
    {label = 'Jetmax', model = 'jetmax', price = 150, image = 'https://media.discordapp.net/attachments/673503448427266059/1261988257412157530/jetmax.png?ex=6694f5a7&is=6693a427&hm=38bfdfa63252b804f6ce29dac403168618d89fc2c8ebe34545ba782ff1c49cf3&=&format=webp&quality=lossless&width=550&height=310'}
}

Config.NPC = {
    {
        model = 's_m_y_dockwork_01', 
        coords = vector3(-1799.37, -1224.10, 0.60), heading = 141.72, 
		spawnCoords = vector4(-1797.38, -1220.83, 0.23, 235.52),
        blip = {
			sprite = 427, 
			scale = 0.8, 
			color = 3, 
			label = "Boat Rentals"
		}
    }
}

Config.ReturnZone = {
    coords = vector3(-1797.95, -1230.96, 0.19),
    radius = 5.0
}