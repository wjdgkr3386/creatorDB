package com.creatorDB.demo;
 
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CreatorDAO {

	List<Map<String, Object>> searchCreator(CreatorDTO creatorDTO);
	
	int isCreator(CreatorDTO creatorDTO);

	int insertCreator(CreatorDTO creatorDTO);

	Map<String, Object> getChannel(CreatorDTO creatorDTO);

	int updateChannel(CreatorDTO creatorDTO);
}
