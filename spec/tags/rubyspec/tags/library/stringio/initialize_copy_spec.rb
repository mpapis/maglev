fails:StringIO#initialize_copy tries to convert the passed argument to a StringIO using #to_strio
fails:StringIO#initialize_copy copies the passed StringIO's content to self
fails:StringIO#initialize_copy copies the passed StringIO's position to self
fails:StringIO#initialize_copy taints self when the passed StringIO is tainted
fails:StringIO#initialize_copy copies the passed StringIO's mode to self
fails:StringIO#initialize_copy copies the passed StringIO's append mode
fails:StringIO#initialize_copy does not truncate self's content when the copied StringIO was in truncate mode
fails:StringIO#initialize_copy makes both StringIO objects to share position, eof status
