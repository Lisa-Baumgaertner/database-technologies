package application.model;

/**
 * Central enum class for defining status values for various entities in the library application.
 */
public class Status {

    /**
     * Enum representing the possible statuses of a book.
     */
    public enum BookStatus {
        AVAILABLE("available"),
        BORROWED("borrowed"),
        RESERVED("reserved"),
        WAITING("waiting"),
        LOST("lost"),
        DAMAGED("damaged"),
        CHECKED_OUT("checked out"),
        IN_MAINTENANCE("in_maintenance");

        private final String status;

        BookStatus(String status) {
            this.status = status;
        }

        public String getStatus() {
            return status;
        }


        public static BookStatus fromString(String status) {
            for (BookStatus bs : BookStatus.values()) {
                if (bs.getStatus().equalsIgnoreCase(status)) {
                    return bs;
                }
            }
            throw new IllegalArgumentException("Unknown BookStatus: " + status);
        }
    }


}
