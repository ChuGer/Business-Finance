dataSource {
  pooled = true
  driverClassName = "com.mysql.jdbc.Driver"
  username = "root"
  password = "123"
}
hibernate {
  cache.use_second_level_cache = true
  cache.use_query_cache = true
  cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
  development {
    dataSource {
      dbCreate = "create-drop" // one of 'create', 'create-drop','update'
      url = "jdbc:mysql://localhost/finance"
    }
  }
  test {
    dataSource {
      dbCreate = "create-drop"
      url = "jdbc:mysql://localhost/finance"
    }
  }
  production {
    dataSource {
      username = "pbx"
      password = "finance"
      dbCreate = "create-drop"
      url = "jdbc:mysql://localhost/pbx"
    }
  }
}