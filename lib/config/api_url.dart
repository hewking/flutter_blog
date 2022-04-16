const apiUrl = 'http://119.29.195.26:7001/default';

const articleListUrl = '$apiUrl/getAriticleList';

const servicePath = {
  'getAriticleList': articleListUrl,
  'getTypeInfo': '$apiUrl/getTypeInfo',
  'getArticleById':'$apiUrl/getArticleById',
  'getListById':'$apiUrl/getListById',
};
