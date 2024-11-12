package application.config;

import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class DatabaseConfig {
    private boolean useMongoDB = false;

    public boolean isUseMongoDB() {
        return useMongoDB;
    }

    public void setUseMongoDB(boolean useMongoDB) {
        this.useMongoDB = useMongoDB;
    }
}
