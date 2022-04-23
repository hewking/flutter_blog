const apiUrl = 'http://119.29.195.26:7001';

const apiClient = '$apiUrl/default';
const apiAdmin = '$apiUrl/admin';

const articleListUrl = '$apiClient/getAriticleList';

const servicePath = {
  'getAriticleList': articleListUrl,
  'getTypeInfo': '$apiClient/getTypeInfo',
  'getArticleById': '$apiClient/getArticleById',
  'getListById': '$apiClient/getListById',
  'addArticle':'$apiAdmin/addArticle',
};
