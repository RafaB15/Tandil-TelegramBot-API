class Version
  MAYOR = 0
  MINOR = 9
  PATCH = 7

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
