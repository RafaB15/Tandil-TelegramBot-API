class Version
  MAYOR = 0
  MINOR = 10
  PATCH = 6

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
