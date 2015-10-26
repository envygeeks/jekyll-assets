class Hash
  def fetch_or_store(key, val)
    fetch(key, nil) || store(key, val)
  end
end
