require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :type, :number_of_wagons
  
  NUMBER_FORMAT = /^[a-z|\d]{3}-*[a-z|\d]{2}$/i
  @@all_trains = []

  def self.all #метод класса (возвращает все поезда)
    @@all_trains
  end
  
  def self.find(number)
    @@all_trains.detect { |train| train.number == number}
  end

  # Имеет номер, тип, количество вагонов (указывается при создани)
  def initialize(number)
    @speed = 0
    @number = number
    @type = nil
    @number_of_wagons = []
    validate!
    register_instances
  end 
  
  def valid?
    validate!
  rescue StandardError
    false
  end
 
  # Может набирать скорость
  def speed
    @speed += 5
  end

   # Может возвращать текущую скорость
  def current_speed
    @speed
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def stop
    @speed = 0
  end

  # Может принимать маршрут следования
  def take_route(route)
    @route_for_train = route
    @pozition_on_route = 0
    @route_for_train.station[pozition_on_route].add_train(self)
  end

  def add_railway_wagon(railway_wagon)
    return false unless railway_wagon.type == @type

    @railway_wagon << railway_wagon if @speed.zero?
  end

  def remove_railway_wagon(railway_wagon)
    @railway_wagon.delete(railway_wagon) if @speed.zero?
  end

  # Может перемещаться вперёд
  def move_forward
    @route_for_train.station[@pozition_on_route].remove_train(self)
    @pozition_on_route += 1
    @route_for_train.station[@pozition_on_route].add_train(self)
  end

  # Может перемещаться назад
  def move_back
    @route_for_train.station[@pozition_on_route].remove_train(self)
    @pozition_on_route -= 1
    @route_for_train.station[@pozition_on_route].add_train(self)
  end

  def show_number_of_wagons
    @number_of_wagons.length
  end

  # Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def show_stations
    [
    @route_for_train.station[@pozition_on_route - 1],
    @route_for_train.station[@pozition_on_route],
    @route_for_train.station[@pozition_on_route + 1]
    ]
  end

  def railway_wagon_to_block(&block)
    @railway_wagon.each_with_index{ |rc, i| block.call(rc, i) }
  end

  protected
  def validate!
    raise 'Number format is not valid!' if number !~ NUMBER_FORMAT
  end
end
