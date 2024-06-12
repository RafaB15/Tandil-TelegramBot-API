class Version
  MAYOR = 0
  MINOR = 12
  PATCH = 2

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
