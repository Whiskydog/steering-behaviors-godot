extends Node2D


var field = []
var cols
var rows
var resolution
var noise = OpenSimplexNoise.new()
var z_off = 0.0


func _init(resolution):
    noise.seed = randi()
    noise.octaves = 20
    noise.period = 5.0
    noise.persistence = 0.2
    noise.lacunarity = 2.5
    self.resolution = resolution


func _ready():
    self.name = 'FlowField'
    var width = get_viewport().size.x
    var height = get_viewport().size.y
    self.cols = int(width / resolution)
    self.rows = int(height / resolution)
    setup()
    self.hide()
    set_process(true)
    $'/root/Global'.connect('update_nodes', self, '_on_global_update_nodes')


func lookup(vec):
    vec -= self.position
    var column = int(clamp(vec.x/resolution, 0, cols-1))
    var row = int(clamp(vec.y/resolution, 0, rows-1))
    return polar2cartesian(1.0, field[column][row].rotation)


func _process(delta):
    var x_off = 0.0
    for i in cols:
        var y_off = 0.0
        for j in rows:
            var theta = range_lerp(noise.get_noise_3d(x_off, y_off, z_off), -1.0, 1.0, -PI*2, PI*2)
            field[i][j].rotation = theta
            y_off += .1
        x_off += .1
    z_off += delta


func setup():
    var x_off = 0.0
    for i in cols:
        var y_off = 0.0

        field.append([])
        field[i] = []

        for j in rows:
            field[i].append([])

            #field[i][j] = preload('arrow.gd').new(
            #        Vector2(i * resolution + resolution/2, j * resolution + resolution/2), 
            #        float(resolution), polar2cartesian(1, randf() * (PI*2)))

            var theta = range_lerp(noise.get_noise_2d(x_off, y_off), -1.0, 1.0, -PI*2, PI*2)
            field[i][j] = preload('arrow.gd').new(
                    Vector2(i * resolution + resolution/2, j * resolution + resolution/2), 
                    float(resolution), Vector2(cos(theta), sin(theta)))
            self.add_child(field[i][j], true)

            y_off += .1
        x_off += .1


func _on_global_update_nodes():
    self.visible = !self.visible