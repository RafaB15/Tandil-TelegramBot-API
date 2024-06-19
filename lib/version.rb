class Version
  MAYOR = 4
  MINOR = 7
  PATCH = 1

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
