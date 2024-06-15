class Version
  MAYOR = 0
  MINOR = 14
  PATCH = 13

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
