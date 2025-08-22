package com.edu.springboot.jpaboard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QBoardEntity is a Querydsl query type for BoardEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBoardEntity extends EntityPathBase<BoardEntity> {

    private static final long serialVersionUID = 1052129456L;

    public static final QBoardEntity boardEntity = new QBoardEntity("boardEntity");

    public final NumberPath<Long> boardIdx = createNumber("boardIdx", Long.class);

    public final NumberPath<Integer> category = createNumber("category", Integer.class);

    public final StringPath content = createString("content");

    public final ListPath<BoardImageEntity, QBoardImageEntity> images = this.<BoardImageEntity, QBoardImageEntity>createList("images", BoardImageEntity.class, QBoardImageEntity.class, PathInits.DIRECT2);

    public final ListPath<LikeEntity, QLikeEntity> likes = this.<LikeEntity, QLikeEntity>createList("likes", LikeEntity.class, QLikeEntity.class, PathInits.DIRECT2);

    public final NumberPath<Integer> likesCount = createNumber("likesCount", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> postdate = createDateTime("postdate", java.time.LocalDateTime.class);

    public final NumberPath<Integer> report = createNumber("report", Integer.class);

    public final StringPath sfile = createString("sfile");

    public final StringPath title = createString("title");

    public final StringPath userId = createString("userId");

    public final NumberPath<Integer> visitcount = createNumber("visitcount", Integer.class);

    public QBoardEntity(String variable) {
        super(BoardEntity.class, forVariable(variable));
    }

    public QBoardEntity(Path<? extends BoardEntity> path) {
        super(path.getType(), path.getMetadata());
    }

    public QBoardEntity(PathMetadata metadata) {
        super(BoardEntity.class, metadata);
    }

}

