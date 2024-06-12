class Version
  MAYOR = 0
  MINOR = 13
  PATCH = 7

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
