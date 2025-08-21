package com.edu.springboot.qnaBoard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QQnaBoardEntity is a Querydsl query type for QnaBoardEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QQnaBoardEntity extends EntityPathBase<QnaBoardEntity> {

    private static final long serialVersionUID = 167726567L;

    public static final QQnaBoardEntity qnaBoardEntity = new QQnaBoardEntity("qnaBoardEntity");

    public final StringPath answercontent = createString("answercontent");

    public final StringPath answerstatus = createString("answerstatus");

    public final StringPath category = createString("category");

    public final StringPath content = createString("content");

    public final NumberPath<Long> idx = createNumber("idx", Long.class);

    public final NumberPath<Integer> likes = createNumber("likes", Integer.class);

    public final StringPath noticeflag = createString("noticeflag");

    public final DateTimePath<java.time.LocalDateTime> postdate = createDateTime("postdate", java.time.LocalDateTime.class);

    public final StringPath secretflag = createString("secretflag");

    public final StringPath title = createString("title");

    public final DateTimePath<java.time.LocalDateTime> updatedate = createDateTime("updatedate", java.time.LocalDateTime.class);

    public final NumberPath<Integer> views = createNumber("views", Integer.class);

    public final StringPath writer = createString("writer");

    public final StringPath writerid = createString("writerid");

    public QQnaBoardEntity(String variable) {
        super(QnaBoardEntity.class, forVariable(variable));
    }

    public QQnaBoardEntity(Path<? extends QnaBoardEntity> path) {
        super(path.getType(), path.getMetadata());
    }

    public QQnaBoardEntity(PathMetadata metadata) {
        super(QnaBoardEntity.class, metadata);
    }

}

