
import 'response_parser.dart';

/// Implementation of <code>ResponseParser<code> with JAXB.
 class JAXBResponseParser implements ResponseParser<Object> {

     static final SAXParserFactory saxParserFactory = SAXParserFactory.newInstance("com.sun.org.apache.xerces.internal.jaxp.SAXParserFactoryImpl",null);

    // It allows to specify the class type, if the class type is specified,
    // the contextPath will be ignored.
     Class<?> modelClass;

    // Because JAXBContext.newInstance() is a very slow method,
    // it can improve performance a lot to cache the instances of JAXBContext
    // for used context paths or class types.
     static HashMap<Object, JAXBContext> cachedContexts = new HashMap<Object, JAXBContext>();

    static {
        saxParserFactory.setNamespaceAware(true);
        saxParserFactory.setValidating(false);
        try {
            saxParserFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            saxParserFactory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
            saxParserFactory.setFeature("http://xml.org/sax/features/external-general-entities", false);
            saxParserFactory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
        } catch (Exception e) {
        }
    }

     JAXBResponseParser(Class<?> modelClass) {
        assert (modelClass != null);
        this.modelClass = modelClass;
    }

     Object parse(ResponseMessage response) throws ResponseParseException {
        assert (response != null && response.getContent() != null);
        return getObject(response.getContent());
    }

     Object getObject(InputStream responseContent) throws ResponseParseException {
        try {
            if (!cachedContexts.containsKey(modelClass)) {
                initJAXBContext(modelClass);
            }

            assert (cachedContexts.containsKey(modelClass));
            JAXBContext jc = cachedContexts.get(modelClass);
            Unmarshaller um = jc.createUnmarshaller();
            // It performs better to call Unmarshaller#unmarshal(Source)
            // than to call Unmarshaller#unmarshall(InputStream)
            // if XMLReader is specified in the SAXSource instance.
            return um.unmarshal(getSAXSource(responseContent));
        } catch (JAXBException e) {
            throw new ResponseParseException(
                    COMMON_RESOURCE_MANAGER.getFormattedString("FailedToParseResponse", e.getMessage()), e);
        } catch (SAXException e) {
            throw new ResponseParseException(
                    COMMON_RESOURCE_MANAGER.getFormattedString("FailedToParseResponse", e.getMessage()), e);
        } catch (ParserConfigurationException e) {
            throw new ResponseParseException(
                    COMMON_RESOURCE_MANAGER.getFormattedString("FailedToParseResponse", e.getMessage()), e);
        }
    }

     static synchronized void initJAXBContext(Class<?> c) throws JAXBException {
        if (!cachedContexts.containsKey(c)) {
            JAXBContext jc = JAXBContext.newInstance(c);
            cachedContexts.put(c, jc);
        }
    }

     static SAXSource getSAXSource(InputStream content) throws SAXException, ParserConfigurationException {
        SAXParser saxParser = saxParserFactory.newSAXParser();
        return new SAXSource(saxParser.getXMLReader(), new InputSource(content));
    }
}