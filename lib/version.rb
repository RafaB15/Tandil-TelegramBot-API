class Version
  MAYOR = 0
  MINOR = 10
  PATCH = 7

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
