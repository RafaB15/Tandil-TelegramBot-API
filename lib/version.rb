class Version
  MAYOR = 0
  MINOR = 10
  PATCH = 11

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
