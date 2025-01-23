package application.repository;

import application.model.Keyword;

import java.util.List;

public interface KeywordRepository {

    List<Keyword> getKeywordsForBook(long bookId);
    int getKeywordIdByName(String keywordName);
    int insertKeyword(String keywordName);
}
