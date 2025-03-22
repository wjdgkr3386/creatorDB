package com.creatorDB.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;


@RestController
@RequestMapping("/api/youtube")
public class YoutubeAPIConfigController {

	private final EnvRunner envRunner;
	private final String API_KEY;
	
    public YoutubeAPIConfigController(EnvRunner envRunner) {
        this.envRunner = envRunner;
        API_KEY = envRunner.getAPI_KEY();
    }
    
    @GetMapping("/search")
    public String searchYoutube(@RequestParam String keyword) {
    	RestTemplate restTemplate = new RestTemplate();
        String URL = "https://www.googleapis.com/youtube/v3/search?&q="+keyword+"&type=channel&key="+API_KEY;
        return restTemplate.getForObject(URL, String.class);
    }
    
    @GetMapping("/channel")
    public String getChannelYoutube(@RequestParam String channelId) {
    	RestTemplate restTemplate = new RestTemplate();
        String URL = "https://www.googleapis.com/youtube/v3/channels?&part=brandingSettings,statistics,snippet&maxResults=1&id="+channelId+"&key="+API_KEY;
        
        return restTemplate.getForObject(URL, String.class);
    }
}
