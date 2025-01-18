package application.model;

public class Keyword {
    private int keywordId;
    private String keyword;

    public Keyword(int keywordId, String keyword) {
        this.keywordId = keywordId;
        this.keyword = keyword;
    }

    public int getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(int keywordId) {
        this.keywordId = keywordId;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
}

