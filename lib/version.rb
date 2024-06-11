class Version
  MAYOR = 0
  MINOR = 10
  PATCH = 9

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
