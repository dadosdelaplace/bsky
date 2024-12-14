install.packages("atrrr")
library(atrrr)
# atrrr::auth(user = "dadosdelaplace.bsky.social", password = "Imaginativo_1989")

followers_neighb <-
  list("k0" = list("dadosdelaplace.bsky.social" =
                     get_followers("dadosdelaplace.bsky.social", limit = 1e6)))

scrapped_users <- names(followers_neighb$k1)
for (i in 1:length(followers_neighb$k0)) {
  for (j in 1:nrow(followers_neighb$k0[[i]])) {
    
    if (!(followers_neighb$k0[[i]]$actor_handle[j] %in% scrapped_users)) {
      get_aux <- tryCatch(get_followers(followers_neighb$k0[[i]]$actor_handle[j], limit = 1e5),
                          error = function(e) { -1 })
      
      n_errors <- 0
      if (is.numeric(get_aux)) {
        while (get_aux == -1) {
        
          Sys.sleep(10)
          get_aux <-
            tryCatch(get_followers(followers_neighb$k0[[i]]$actor_handle[j], limit = 1e5),
                     error = function(e) { -1 })
          
          n_errors <- n_errors + 1
          if (!is.numeric(get_aux)) { next }
          if (n_errors > 10 ) { next }
        }
      }
      followers_neighb[["k1"]][[followers_neighb$k0[[i]]$actor_handle[j]]] <-
        get_aux
    }
  }
}
