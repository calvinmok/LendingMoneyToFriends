




#define NUBLE_OBJECT_TEMPLATE(TYPE) \
\
	typedef struct \
	{ \
		Bool hasVar; \
		TYPE* vd; \
	} \
	Nuble##TYPE; \
\
	NS_INLINE Nuble##TYPE TYPE##_createNuble(Bool hasVar, TYPE* vd) \
	{ \
		Nuble##TYPE result = { hasVar, vd }; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_nuble() \
	{ \
		Nuble##TYPE result = { No, nil }; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_toNuble(TYPE* vd) \
	{ \
		if (vd == nil) return TYPE##_nuble(); \
		\
		Nuble##TYPE result = { Yes, vd }; \
		return result; \
	} \
\
	NS_INLINE TYPE* TYPE##_varOr(Nuble##TYPE n, TYPE* def) \
	{ \
		return (n.hasVar) ? n.vd : def; \
	} \
\
	NS_INLINE TYPE* TYPE##_var(Nuble##TYPE n) \
	{ \
		ASSERT(n.hasVar); return n.vd; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_retain(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd retain]; \
		return n; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_release(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd release]; \
		return n; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_autorelease(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd autorelease]; \
		return n; \
	} \
 





	
#define NUBLE_STRUCT_TEMPLATE(TYPE) \
\
	typedef struct \
	{ \
		Bool hasVar; \
		TYPE vd; \
	} \
	Nuble##TYPE; \
\
	NS_INLINE Nuble##TYPE TYPE##_createNuble(Bool hasVar, TYPE vd) \
	{ \
		Nuble##TYPE result; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_nuble() \
	{ \
		Nuble##TYPE result; \
		memset(&result, 0, sizeof(Nuble##TYPE)); \
		result.hasVar = No; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_toNuble(TYPE vd) \
	{ \
		Nuble##TYPE result = { Yes, vd }; \
		return result; \
	} \
\
	NS_INLINE TYPE TYPE##_varOr(Nuble##TYPE n, TYPE def) \
	{ \
		return (n.hasVar) ? n.vd : def; \
	} \
\
	NS_INLINE TYPE TYPE##_var(Nuble##TYPE n) \
	{ \
		ASSERT(n.hasVar); return n.vd; \
	} \
		



















