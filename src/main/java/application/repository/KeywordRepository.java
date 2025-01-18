package application.repository;

import application.model.Keyword;

import java.util.List;

public interface KeywordRepository {

    List<Keyword> getKeywordsForBook(long bookId);
}
