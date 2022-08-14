require_relative 'manufacturer'
require_relative 'instance_counter'

class Station
  include Manufacturer
  include InstanceCounter
  attr_reader :name

  TITLE_FORMAT = /[a-z]/i
  @@all_station = []

  # метод класса (возвращает все станции)
  def self.all
    @@all_station
  end

  # Имеет название, которое указывается при ее создании
  def initialize(name)
    @name = name
    validate!
    @trains = []
    register_instances
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  # Может принимать поезда (по одному за раз)
  def add_train(train)
    return if @trains.include?(train)
    @trains << train
  end

  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def train_list
    @trains
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def train_list_type(type)
    @trains.select do |train|
      train.type == type
    end
  end

  # Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def delete_train(train)
    @trains.delete(train)
  end

  def show_name
    @name
  end

  def trains_to_block(&block)
    @trains.each { |train| block.call(train) }
  end

  protected

  def validate!
    raise "Title format is not valid!" if name !~ TITLE_FORMAT
  end
end
